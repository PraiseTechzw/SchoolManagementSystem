import 'package:flutter/foundation.dart';

import '../enums/app_enums.dart';
import '../services/firebase_service.dart';
import '../services/local_storage_service.dart';
import '../services/connectivity_service.dart';

/// Utility class for handling data synchronization between local and cloud storage
class SyncUtils {
  static final ConnectivityService _connectivityService = ConnectivityService();
  
  /// Synchronize an item between local storage and Firestore
  static Future<void> syncItem({
    required String boxName,
    required String itemId,
    required String collectionName,
  }) async {
    try {
      // Check if internet is available
      final isConnected = await _connectivityService.checkConnectivity();
      if (!isConnected) {
        debugPrint('Cannot sync item, no internet connection');
        return;
      }
      
      // Get the box based on name
      final box = _getBoxByName(boxName);
      if (box == null) {
        debugPrint('Invalid box name: $boxName');
        return;
      }
      
      // Get item from local storage
      final localItem = LocalStorageService.getItemById(box, itemId);
      if (localItem == null) {
        debugPrint('Local item not found: $boxName/$itemId');
        return;
      }
      
      // Check if item is marked for deletion
      final isDeleted = localItem['isDeleted'] as bool? ?? false;
      
      if (isDeleted) {
        // Delete from Firestore
        await FirebaseService.deleteDocument(
          collection: collectionName,
          documentId: itemId,
        );
        
        // Hard delete from local storage
        await LocalStorageService.hardDeleteItem(box, itemId);
        
        debugPrint('Item deleted from Firestore: $collectionName/$itemId');
        return;
      }
      
      // Get current timestamp
      final now = DateTime.now().toIso8601String();
      
      // Prepare data for Firestore (remove sync metadata)
      final dataForFirestore = Map<String, dynamic>.from(localItem)
        ..remove('syncStatus')
        ..addAll({
          'lastSynced': now,
        });
      
      // Check if document exists in Firestore
      final docSnapshot = await FirebaseService.getDocument(
        collection: collectionName,
        documentId: itemId,
      );
      
      if (docSnapshot.exists) {
        // Update existing document
        await FirebaseService.updateDocument(
          collection: collectionName,
          documentId: itemId,
          data: dataForFirestore,
        );
      } else {
        // Create new document with ID
        await FirebaseService.firestore
            .collection(collectionName)
            .doc(itemId)
            .set(dataForFirestore);
      }
      
      // Update sync status in local storage
      await LocalStorageService.updateSyncStatus(
        box,
        itemId,
        SyncStatus.completed,
      );
      
      debugPrint('Item synced to Firestore: $collectionName/$itemId');
    } catch (e) {
      debugPrint('Error syncing item: $e');
      
      // Get the box based on name
      final box = _getBoxByName(boxName);
      if (box != null) {
        // Update sync status to error
        await LocalStorageService.updateSyncStatus(
          box,
          itemId,
          SyncStatus.error,
        );
      }
    }
  }
  
  /// Synchronize all pending items in the sync queue
  static Future<void> syncPendingItems() async {
    try {
      // Check if internet is available
      final isConnected = await _connectivityService.checkConnectivity();
      if (!isConnected) {
        debugPrint('Cannot sync pending items, no internet connection');
        return;
      }
      
      // Get sync queue
      final syncQueue = LocalStorageService.getSyncQueue();
      
      if (syncQueue.isEmpty) {
        debugPrint('No pending items to sync');
        return;
      }
      
      debugPrint('Syncing ${syncQueue.length} pending items');
      
      // Process each item in the queue
      for (final item in syncQueue) {
        // Parse box name and item ID
        final parts = item.split(':');
        if (parts.length != 2) continue;
        
        final boxName = parts[0];
        final itemId = parts[1];
        
        // Map box name to collection name
        final collectionName = _mapBoxToCollection(boxName);
        
        // Sync the item
        await syncItem(
          boxName: boxName,
          itemId: itemId,
          collectionName: collectionName,
        );
      }
      
      debugPrint('Sync completed for all pending items');
    } catch (e) {
      debugPrint('Error syncing pending items: $e');
    }
  }
  
  /// Synchronize items from Firestore to local storage
  static Future<void> pullFromFirestore({
    required String collectionName,
    required String boxName,
    DateTime? since,
  }) async {
    try {
      // Check if internet is available
      final isConnected = await _connectivityService.checkConnectivity();
      if (!isConnected) {
        debugPrint('Cannot pull from Firestore, no internet connection');
        return;
      }
      
      // Get the box based on name
      final box = _getBoxByName(boxName);
      if (box == null) {
        debugPrint('Invalid box name: $boxName');
        return;
      }
      
      // Build query
      List<List<dynamic>>? whereConditions;
      
      if (since != null) {
        whereConditions = [
          ['lastUpdated', '>=', since.toIso8601String()],
        ];
      }
      
      // Get documents from Firestore
      final querySnapshot = await FirebaseService.getDocuments(
        collection: collectionName,
        whereConditions: whereConditions,
      );
      
      // Process documents
      for (final doc in querySnapshot.docs) {
        final remoteData = doc.data();
        final id = doc.id;
        
        // Check if document exists locally
        final localItem = LocalStorageService.getItemById(box, id);
        
        if (localItem != null) {
          // Check if local item is marked for deletion
          final isLocalDeleted = localItem['isDeleted'] as bool? ?? false;
          
          if (isLocalDeleted) {
            // Skip this document, it will be deleted during next sync
            continue;
          }
          
          // Check if remote data is newer
          final localUpdated = localItem['lastUpdated'] as String? ?? '';
          final remoteUpdated = remoteData['lastUpdated'] as String? ?? '';
          
          if (remoteUpdated.isNotEmpty && localUpdated.isNotEmpty) {
            final localDate = DateTime.parse(localUpdated);
            final remoteDate = DateTime.parse(remoteUpdated);
            
            if (remoteDate.isAfter(localDate)) {
              // Remote data is newer, update local
              final mergedData = FirebaseService.mergeData(
                localData: localItem,
                remoteData: remoteData,
                conflictResolutionFields: [
                  'name', 'description', 'amount', 'date', 'status',
                  'type', 'score', 'subject', 'class', 'term',
                ],
              );
              
              // Add sync metadata
              mergedData['syncStatus'] = SyncStatus.completed.toString();
              
              // Save to local storage
              await box.put(id, mergedData);
            }
          }
        } else {
          // Document does not exist locally, create it
          final dataForLocal = {
            ...remoteData,
            'id': id,
            'syncStatus': SyncStatus.completed.toString(),
          };
          
          // Save to local storage
          await box.put(id, dataForLocal);
        }
      }
      
      debugPrint('Pull from Firestore completed for $collectionName');
    } catch (e) {
      debugPrint('Error pulling from Firestore: $e');
    }
  }
  
  /// Full synchronization process (push pending changes, then pull updates)
  static Future<void> fullSync() async {
    try {
      // Push pending changes first
      await syncPendingItems();
      
      // Pull updates for each collection
      await pullFromFirestore(
        collectionName: 'users',
        boxName: 'user_box',
      );
      
      await pullFromFirestore(
        collectionName: 'students',
        boxName: 'student_box',
      );
      
      await pullFromFirestore(
        collectionName: 'classes',
        boxName: 'class_box',
      );
      
      await pullFromFirestore(
        collectionName: 'payments',
        boxName: 'payment_box',
      );
      
      await pullFromFirestore(
        collectionName: 'attendance',
        boxName: 'attendance_box',
      );
      
      await pullFromFirestore(
        collectionName: 'grades',
        boxName: 'grade_box',
      );
      
      await pullFromFirestore(
        collectionName: 'announcements',
        boxName: 'announcement_box',
      );
      
      await pullFromFirestore(
        collectionName: 'schools',
        boxName: 'school_box',
      );
      
      debugPrint('Full sync completed');
    } catch (e) {
      debugPrint('Error during full sync: $e');
    }
  }
  
  /// Get a Hive box by name
  static dynamic _getBoxByName(String boxName) {
    switch (boxName) {
      case 'user_box':
        return LocalStorageService.userBox;
      case 'student_box':
        return LocalStorageService.studentBox;
      case 'class_box':
        return LocalStorageService.classBox;
      case 'payment_box':
        return LocalStorageService.paymentBox;
      case 'attendance_box':
        return LocalStorageService.attendanceBox;
      case 'grade_box':
        return LocalStorageService.gradeBox;
      case 'announcement_box':
        return LocalStorageService.announcementBox;
      case 'school_box':
        return LocalStorageService.schoolBox;
      default:
        return null;
    }
  }
  
  /// Map box name to Firestore collection name
  static String _mapBoxToCollection(String boxName) {
    switch (boxName) {
      case 'user_box':
        return 'users';
      case 'student_box':
        return 'students';
      case 'class_box':
        return 'classes';
      case 'payment_box':
        return 'payments';
      case 'attendance_box':
        return 'attendance';
      case 'grade_box':
        return 'grades';
      case 'announcement_box':
        return 'announcements';
      case 'school_box':
        return 'schools';
      default:
        return boxName.replaceAll('_box', '');
    }
  }
}
