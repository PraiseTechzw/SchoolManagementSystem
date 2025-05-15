import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

import '../services/firebase_service.dart';
import '../services/local_storage_service.dart';
import '../../config/app_config.dart';
import '../enums/app_enums.dart';

/// Utilities for handling data synchronization between local storage and Firebase
class SyncUtils {
  static final Connectivity _connectivity = Connectivity();
  static StreamSubscription<ConnectivityResult>? _subscription;
  static bool _isSyncing = false;
  static Timer? _syncTimer;
  
  /// Start listening to connectivity changes
  static void startListening() {
    if (_subscription != null) return;
    
    _subscription = _connectivity.onConnectivityChanged.listen((result) {
      if (result != ConnectivityResult.none) {
        // When connection is restored, trigger sync
        syncPendingData();
      }
    });
    
    // Start periodic sync timer
    _startPeriodicSync();
  }
  
  /// Stop listening to connectivity changes
  static void stopListening() {
    _subscription?.cancel();
    _subscription = null;
    _syncTimer?.cancel();
    _syncTimer = null;
  }
  
  /// Start periodic sync timer
  static void _startPeriodicSync() {
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(
      Duration(minutes: AppConfig.syncIntervalMinutes),
      (_) => syncPendingData(),
    );
  }
  
  /// Check if device is currently connected to the internet
  static Future<bool> checkConnectivity() async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }
  
  /// Sync pending data to Firestore
  static Future<void> syncPendingData() async {
    if (_isSyncing) return;
    
    final isConnected = await checkConnectivity();
    if (!isConnected) return;
    
    _isSyncing = true;
    
    try {
      // Get the sync queue
      final syncQueue = LocalStorageService.getSyncQueue();
      if (syncQueue.isEmpty) {
        _isSyncing = false;
        return;
      }
      
      debugPrint('Syncing ${syncQueue.length} items...');
      
      // Process each item in the queue
      for (final item in syncQueue.toList()) {
        final parts = item.split(':');
        if (parts.length != 2) continue;
        
        final boxName = parts[0];
        final itemId = parts[1];
        
        await _syncItem(boxName, itemId);
      }
      
      // Update last sync timestamp
      final now = DateTime.now();
      await LocalStorageService.saveSetting(AppConfig.lastSyncKey, now.toIso8601String());
      debugPrint('Sync completed successfully at ${now.toIso8601String()}');
    } catch (e) {
      debugPrint('Error syncing data: $e');
    } finally {
      _isSyncing = false;
    }
  }
  
  /// Sync a specific item to Firestore
  static Future<void> _syncItem(String boxName, String itemId) async {
    try {
      // Get the box
      final box = _getBoxByName(boxName);
      if (box == null) return;
      
      // Get the item
      final item = box.get(itemId);
      if (item == null) return;
      
      // Convert to Map
      final itemData = item is Map ? Map<String, dynamic>.from(item) : item as Map<String, dynamic>;
      
      // Check if it's marked as deleted
      final isDeleted = itemData['isDeleted'] == true;
      
      // Get the collection name
      final collectionName = _getCollectionName(boxName);
      if (collectionName == null) return;
      
      if (isDeleted) {
        // Delete from Firestore
        await FirebaseService.deleteDocument(
          collection: collectionName,
          documentId: itemId,
        );
        
        // Hard delete from local storage after successful sync
        await LocalStorageService.hardDeleteItem(box, itemId);
      } else {
        // Try to get the document from Firestore first
        final doc = await FirebaseService.getDocument(
          collection: collectionName,
          documentId: itemId,
        );
        
        if (doc.exists) {
          // Document exists in Firestore, merge data
          final remoteData = doc.data()!;
          
          // Conflict resolution fields to check
          final conflictFields = [
            'lastUpdated',
            'modifiedAt',
            'updatedAt',
            'timestamp',
          ];
          
          // Merge local and remote data
          final mergedData = FirebaseService.mergeData(
            localData: itemData,
            remoteData: remoteData,
            conflictResolutionFields: conflictFields,
          );
          
          // Update in Firestore
          await FirebaseService.updateDocument(
            collection: collectionName,
            documentId: itemId,
            data: mergedData,
          );
          
          // Update local copy with merged data
          mergedData['syncStatus'] = SyncStatus.completed.toString();
          await box.put(itemId, mergedData);
        } else {
          // Document doesn't exist in Firestore, create it
          itemData['syncStatus'] = SyncStatus.completed.toString();
          
          // Update in Firestore
          await FirebaseService.updateDocument(
            collection: collectionName,
            documentId: itemId,
            data: itemData,
          );
          
          // Update local copy with sync status
          await box.put(itemId, itemData);
        }
        
        // Remove from sync queue
        await LocalStorageService.removeFromSyncQueue(boxName, itemId);
      }
    } catch (e) {
      debugPrint('Error syncing item $boxName:$itemId: $e');
      
      // Mark as error in local storage
      final box = _getBoxByName(boxName);
      if (box != null) {
        await LocalStorageService.updateSyncStatus(
          box,
          itemId,
          SyncStatus.error,
        );
      }
    }
  }
  
  /// Get Hive box by name
  static Box? _getBoxByName(String boxName) {
    switch (boxName) {
      case AppConfig.userBox:
        return LocalStorageService.userBox;
      case AppConfig.studentBox:
        return LocalStorageService.studentBox;
      case AppConfig.classBox:
        return LocalStorageService.classBox;
      case AppConfig.paymentBox:
        return LocalStorageService.paymentBox;
      case AppConfig.attendanceBox:
        return LocalStorageService.attendanceBox;
      case AppConfig.gradeBox:
        return LocalStorageService.gradeBox;
      case AppConfig.announcementBox:
        return LocalStorageService.announcementBox;
      case AppConfig.schoolBox:
        return LocalStorageService.schoolBox;
      default:
        return null;
    }
  }
  
  /// Get Firestore collection name by box name
  static String? _getCollectionName(String boxName) {
    switch (boxName) {
      case AppConfig.userBox:
        return AppConfig.usersCollection;
      case AppConfig.studentBox:
        return AppConfig.studentsCollection;
      case AppConfig.classBox:
        return AppConfig.classesCollection;
      case AppConfig.paymentBox:
        return AppConfig.paymentsCollection;
      case AppConfig.attendanceBox:
        return AppConfig.attendanceCollection;
      case AppConfig.gradeBox:
        return AppConfig.gradesCollection;
      case AppConfig.announcementBox:
        return AppConfig.announcementsCollection;
      case AppConfig.schoolBox:
        return AppConfig.schoolsCollection;
      default:
        return null;
    }
  }
  
  /// Perform a full sync of all data
  static Future<void> fullSync() async {
    await syncPendingData();
  }
  
  /// Get the number of pending sync items
  static int getPendingSyncCount() {
    return LocalStorageService.getSyncQueue().length;
  }
  
  /// Get the last sync time
  static DateTime? getLastSyncTime() {
    final lastSync = LocalStorageService.getSetting(AppConfig.lastSyncKey) as String?;
    if (lastSync == null) return null;
    
    try {
      return DateTime.parse(lastSync);
    } catch (e) {
      return null;
    }
  }
}