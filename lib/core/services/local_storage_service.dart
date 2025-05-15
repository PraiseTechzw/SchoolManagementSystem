import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../config/app_config.dart';
import '../enums/app_enums.dart';

/// Service for handling local storage operations using Hive
class LocalStorageService {
  // Hive box instances
  static late Box _userBox;
  static late Box _studentBox;
  static late Box _classBox;
  static late Box _paymentBox;
  static late Box _attendanceBox;
  static late Box _gradeBox;
  static late Box _announcementBox;
  static late Box _schoolBox;
  static late Box _settingsBox;
  static late Box _syncBox;
  
  // Secure storage for encryption key
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  
  // Getters for Hive boxes
  static Box get userBox => _userBox;
  static Box get studentBox => _studentBox;
  static Box get classBox => _classBox;
  static Box get paymentBox => _paymentBox;
  static Box get attendanceBox => _attendanceBox;
  static Box get gradeBox => _gradeBox;
  static Box get announcementBox => _announcementBox;
  static Box get schoolBox => _schoolBox;
  static Box get settingsBox => _settingsBox;
  static Box get syncBox => _syncBox;
  
  // UUID generator
  static final Uuid _uuid = Uuid();
  
  /// Initialize Hive boxes
  static Future<void> initialize() async {
    try {
      // Get encryption key from secure storage or generate a new one
      String? encryptionKey = await _secureStorage.read(key: 'hive_encryption_key');
      
      if (encryptionKey == null) {
        final key = Uuid().v4();
        await _secureStorage.write(key: 'hive_encryption_key', value: key);
        encryptionKey = key;
      }
      
      // Register adapters here if needed
      
      // Open Hive boxes
      _userBox = await Hive.openBox(AppConfig.userBox);
      _studentBox = await Hive.openBox(AppConfig.studentBox);
      _classBox = await Hive.openBox(AppConfig.classBox);
      _paymentBox = await Hive.openBox(AppConfig.paymentBox);
      _attendanceBox = await Hive.openBox(AppConfig.attendanceBox);
      _gradeBox = await Hive.openBox(AppConfig.gradeBox);
      _announcementBox = await Hive.openBox(AppConfig.announcementBox);
      _schoolBox = await Hive.openBox(AppConfig.schoolBox);
      _settingsBox = await Hive.openBox(AppConfig.settingsBox);
      _syncBox = await Hive.openBox('sync_box');
      
      debugPrint('LocalStorageService initialized successfully');
    } catch (e) {
      debugPrint('Error initializing LocalStorageService: $e');
      // Fallback to non-encrypted boxes if encryption fails
      _userBox = await Hive.openBox(AppConfig.userBox);
      _studentBox = await Hive.openBox(AppConfig.studentBox);
      _classBox = await Hive.openBox(AppConfig.classBox);
      _paymentBox = await Hive.openBox(AppConfig.paymentBox);
      _attendanceBox = await Hive.openBox(AppConfig.attendanceBox);
      _gradeBox = await Hive.openBox(AppConfig.gradeBox);
      _announcementBox = await Hive.openBox(AppConfig.announcementBox);
      _schoolBox = await Hive.openBox(AppConfig.schoolBox);
      _settingsBox = await Hive.openBox(AppConfig.settingsBox);
      _syncBox = await Hive.openBox('sync_box');
    }
  }
  
  /// Generate a unique ID
  static String generateId() {
    return _uuid.v4();
  }
  
  /// Get all items from a box
  static List<Map<String, dynamic>> getAllItems(Box box) {
    return box.values
        .map((item) => item is Map ? Map<String, dynamic>.from(item) : item as Map<String, dynamic>)
        .toList();
  }
  
  /// Get item by ID from a box
  static Map<String, dynamic>? getItemById(Box box, String id) {
    final item = box.get(id);
    if (item != null) {
      return item is Map ? Map<String, dynamic>.from(item) : item as Map<String, dynamic>;
    }
    return null;
  }
  
  /// Save item to a box with sync status
  static Future<void> saveItem(Box box, String id, Map<String, dynamic> data) async {
    // Add sync metadata
    final itemWithMetadata = {
      ...data,
      'id': id,
      'lastUpdated': DateTime.now().toIso8601String(),
      'syncStatus': SyncStatus.pending.toString(),
    };
    
    await box.put(id, itemWithMetadata);
    
    // Add to sync queue
    await _addToSyncQueue(box.name, id);
  }
  
  /// Add item to sync queue
  static Future<void> _addToSyncQueue(String boxName, String itemId) async {
    final syncQueue = _syncBox.get('queue', defaultValue: []) as List;
    
    if (!syncQueue.contains('$boxName:$itemId')) {
      syncQueue.add('$boxName:$itemId');
      await _syncBox.put('queue', syncQueue);
    }
  }
  
  /// Get sync queue
  static List<String> getSyncQueue() {
    return (_syncBox.get('queue', defaultValue: []) as List).cast<String>();
  }
  
  /// Remove item from sync queue
  static Future<void> removeFromSyncQueue(String boxName, String itemId) async {
    final syncQueue = _syncBox.get('queue', defaultValue: []) as List;
    
    syncQueue.remove('$boxName:$itemId');
    await _syncBox.put('queue', syncQueue);
  }
  
  /// Update sync status for an item
  static Future<void> updateSyncStatus(
    Box box,
    String id,
    SyncStatus status,
  ) async {
    final item = box.get(id);
    
    if (item != null) {
      final updatedItem = {
        ...item is Map ? Map<String, dynamic>.from(item) : item as Map<String, dynamic>,
        'syncStatus': status.toString(),
      };
      
      await box.put(id, updatedItem);
      
      if (status == SyncStatus.synced) {
        await removeFromSyncQueue(box.name, id);
      }
    }
  }
  
  /// Delete item from a box
  static Future<void> deleteItem(Box box, String id) async {
    // Mark as deleted instead of actually deleting
    // This allows syncing deletions to the cloud
    final item = box.get(id);
    
    if (item != null) {
      final updatedItem = {
        ...item is Map ? Map<String, dynamic>.from(item) : item as Map<String, dynamic>,
        'isDeleted': true,
        'deletedAt': DateTime.now().toIso8601String(),
        'syncStatus': SyncStatus.pending.toString(),
      };
      
      await box.put(id, updatedItem);
      await _addToSyncQueue(box.name, id);
    }
  }
  
  /// Hard delete item from a box (after sync)
  static Future<void> hardDeleteItem(Box box, String id) async {
    await box.delete(id);
    await removeFromSyncQueue(box.name, id);
  }
  
  /// Query items from a box with conditions
  static List<Map<String, dynamic>> queryItems(
    Box box, {
    required bool Function(Map<String, dynamic> item) condition,
  }) {
    return box.values
        .map((item) => item is Map ? Map<String, dynamic>.from(item) : item as Map<String, dynamic>)
        .where((item) => !item.containsKey('isDeleted') || item['isDeleted'] != true)
        .where(condition)
        .toList();
  }
  
  /// Get settings value
  static dynamic getSetting(String key, {dynamic defaultValue}) {
    return _settingsBox.get(key, defaultValue: defaultValue);
  }
  
  /// Save settings value
  static Future<void> saveSetting(String key, dynamic value) async {
    await _settingsBox.put(key, value);
  }
  
  /// Clear all boxes (for logout)
  static Future<void> clearAllBoxes() async {
    await Future.wait([
      _userBox.clear(),
      _studentBox.clear(),
      _classBox.clear(),
      _paymentBox.clear(),
      _attendanceBox.clear(),
      _gradeBox.clear(),
      _announcementBox.clear(),
      _schoolBox.clear(),
      _syncBox.clear(),
    ]);
  }
  
  /// Export all data to JSON
  static String exportAllData() {
    final exportData = {
      'users': getAllItems(_userBox),
      'students': getAllItems(_studentBox),
      'classes': getAllItems(_classBox),
      'payments': getAllItems(_paymentBox),
      'attendance': getAllItems(_attendanceBox),
      'grades': getAllItems(_gradeBox),
      'announcements': getAllItems(_announcementBox),
      'schools': getAllItems(_schoolBox),
      'settings': _settingsBox.toMap(),
    };
    
    return jsonEncode(exportData);
  }
  
  /// Import data from JSON
  static Future<void> importFromJson(String jsonData) async {
    try {
      final data = jsonDecode(jsonData) as Map<String, dynamic>;
      
      // Clear existing data
      await clearAllBoxes();
      
      // Import users
      if (data.containsKey('users')) {
        for (final user in data['users']) {
          await _userBox.put(user['id'], user);
        }
      }
      
      // Import students
      if (data.containsKey('students')) {
        for (final student in data['students']) {
          await _studentBox.put(student['id'], student);
        }
      }
      
      // Import classes
      if (data.containsKey('classes')) {
        for (final classItem in data['classes']) {
          await _classBox.put(classItem['id'], classItem);
        }
      }
      
      // Import payments
      if (data.containsKey('payments')) {
        for (final payment in data['payments']) {
          await _paymentBox.put(payment['id'], payment);
        }
      }
      
      // Import attendance
      if (data.containsKey('attendance')) {
        for (final attendance in data['attendance']) {
          await _attendanceBox.put(attendance['id'], attendance);
        }
      }
      
      // Import grades
      if (data.containsKey('grades')) {
        for (final grade in data['grades']) {
          await _gradeBox.put(grade['id'], grade);
        }
      }
      
      // Import announcements
      if (data.containsKey('announcements')) {
        for (final announcement in data['announcements']) {
          await _announcementBox.put(announcement['id'], announcement);
        }
      }
      
      // Import schools
      if (data.containsKey('schools')) {
        for (final school in data['schools']) {
          await _schoolBox.put(school['id'], school);
        }
      }
      
      // Import settings
      if (data.containsKey('settings')) {
        final settings = data['settings'] as Map<String, dynamic>;
        for (final entry in settings.entries) {
          await _settingsBox.put(entry.key, entry.value);
        }
      }
      
      debugPrint('Data imported successfully');
    } catch (e) {
      debugPrint('Error importing data: $e');
      rethrow;
    }
  }
}
