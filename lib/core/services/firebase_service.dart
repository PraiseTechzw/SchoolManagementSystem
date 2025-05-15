import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

import '../enums/app_enums.dart';
import '../../features/auth/data/models/user_model.dart';
import '../../config/app_config.dart';

/// Service for handling Firebase operations
class FirebaseService {
  // Firebase instances
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;
  
  // Getters for Firebase instances
  static FirebaseAuth get auth => _auth;
  static FirebaseFirestore get firestore => _firestore;
  static FirebaseStorage get storage => _storage;
  
  /// Initialize Firebase with offline persistence
  static Future<void> initialize() async {
    // Enable offline persistence for Firestore
    await _firestore.enablePersistence(
      const PersistenceSettings(synchronizeTabs: true),
    ).catchError((error) {
      debugPrint('Firestore persistence error: $error');
    });
    
    // Set cache size
    _firestore.settings = const Settings(
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
  }
  
  /// Sign in with email and password
  static Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
  
  /// Sign up with email and password
  static Future<UserCredential> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
  
  /// Sign out the current user
  static Future<void> signOut() async {
    await _auth.signOut();
  }
  
  /// Reset password with email
  static Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
  
  /// Get the current authenticated user
  static User? get currentUser => _auth.currentUser;
  
  /// Check if user is authenticated
  static bool get isAuthenticated => currentUser != null;
  
  /// Get user role from Firestore
  static Future<UserRole> getUserRole(String uid) async {
    try {
      final doc = await _firestore
          .collection(AppConfig.usersCollection)
          .doc(uid)
          .get();
      
      if (doc.exists && doc.data() != null) {
        final userData = doc.data()!;
        final role = userData['role'] as String? ?? 'student';
        return UserRole.fromString(role);
      }
      
      return UserRole.student;
    } catch (e) {
      debugPrint('Error getting user role: $e');
      return UserRole.student;
    }
  }
  
  /// Create or update user data in Firestore
  static Future<void> saveUserData(UserModel user) async {
    await _firestore
        .collection(AppConfig.usersCollection)
        .doc(user.id)
        .set(user.toMap(), SetOptions(merge: true));
  }
  
  /// Get a document from a collection
  static Future<DocumentSnapshot<Map<String, dynamic>>> getDocument({
    required String collection,
    required String documentId,
  }) async {
    return await _firestore.collection(collection).doc(documentId).get();
  }
  
  /// Add a document to a collection
  static Future<DocumentReference<Map<String, dynamic>>> addDocument({
    required String collection,
    required Map<String, dynamic> data,
  }) async {
    return await _firestore.collection(collection).add(data);
  }
  
  /// Update a document in a collection
  static Future<void> updateDocument({
    required String collection,
    required String documentId,
    required Map<String, dynamic> data,
  }) async {
    await _firestore
        .collection(collection)
        .doc(documentId)
        .update(data);
  }
  
  /// Delete a document from a collection
  static Future<void> deleteDocument({
    required String collection,
    required String documentId,
  }) async {
    await _firestore.collection(collection).doc(documentId).delete();
  }
  
  /// Get documents from a collection with query
  static Future<QuerySnapshot<Map<String, dynamic>>> getDocuments({
    required String collection,
    List<List<dynamic>>? whereConditions,
    String? orderBy,
    bool descending = false,
    int? limit,
  }) async {
    Query<Map<String, dynamic>> query = _firestore.collection(collection);
    
    // Apply where conditions
    if (whereConditions != null) {
      for (final condition in whereConditions) {
        if (condition.length >= 3) {
          final field = condition[0] as String;
          final operator = condition[1] as String;
          final value = condition[2];
          
          switch (operator) {
            case '==':
              query = query.where(field, isEqualTo: value);
              break;
            case '!=':
              query = query.where(field, isNotEqualTo: value);
              break;
            case '>':
              query = query.where(field, isGreaterThan: value);
              break;
            case '>=':
              query = query.where(field, isGreaterThanOrEqualTo: value);
              break;
            case '<':
              query = query.where(field, isLessThan: value);
              break;
            case '<=':
              query = query.where(field, isLessThanOrEqualTo: value);
              break;
            case 'array-contains':
              query = query.where(field, arrayContains: value);
              break;
          }
        }
      }
    }
    
    // Apply order by
    if (orderBy != null) {
      query = query.orderBy(orderBy, descending: descending);
    }
    
    // Apply limit
    if (limit != null) {
      query = query.limit(limit);
    }
    
    return await query.get();
  }
  
  /// Stream documents from a collection with query
  static Stream<QuerySnapshot<Map<String, dynamic>>> streamDocuments({
    required String collection,
    List<List<dynamic>>? whereConditions,
    String? orderBy,
    bool descending = false,
    int? limit,
  }) {
    Query<Map<String, dynamic>> query = _firestore.collection(collection);
    
    // Apply where conditions
    if (whereConditions != null) {
      for (final condition in whereConditions) {
        if (condition.length >= 3) {
          final field = condition[0] as String;
          final operator = condition[1] as String;
          final value = condition[2];
          
          switch (operator) {
            case '==':
              query = query.where(field, isEqualTo: value);
              break;
            case '!=':
              query = query.where(field, isNotEqualTo: value);
              break;
            case '>':
              query = query.where(field, isGreaterThan: value);
              break;
            case '>=':
              query = query.where(field, isGreaterThanOrEqualTo: value);
              break;
            case '<':
              query = query.where(field, isLessThan: value);
              break;
            case '<=':
              query = query.where(field, isLessThanOrEqualTo: value);
              break;
            case 'array-contains':
              query = query.where(field, arrayContains: value);
              break;
          }
        }
      }
    }
    
    // Apply order by
    if (orderBy != null) {
      query = query.orderBy(orderBy, descending: descending);
    }
    
    // Apply limit
    if (limit != null) {
      query = query.limit(limit);
    }
    
    return query.snapshots();
  }
  
  /// Stream a document from a collection
  static Stream<DocumentSnapshot<Map<String, dynamic>>> streamDocument({
    required String collection,
    required String documentId,
  }) {
    return _firestore.collection(collection).doc(documentId).snapshots();
  }
  
  /// Execute a batch write
  static Future<void> executeBatch(
    void Function(WriteBatch batch) operations,
  ) async {
    final batch = _firestore.batch();
    operations(batch);
    await batch.commit();
  }
  
  /// Merge local and remote data
  static Map<String, dynamic> mergeData({
    required Map<String, dynamic> localData,
    required Map<String, dynamic> remoteData,
    required List<String> conflictResolutionFields,
  }) {
    final mergedData = {...remoteData};
    
    for (final field in conflictResolutionFields) {
      if (localData.containsKey(field) && 
          remoteData.containsKey(field) && 
          localData[field] != remoteData[field]) {
        // Always prefer the newer timestamp
        if (field.contains('timestamp') || field.contains('date')) {
          final localTimestamp = localData[field] is Timestamp
              ? (localData[field] as Timestamp).toDate()
              : DateTime.parse(localData[field].toString());
          
          final remoteTimestamp = remoteData[field] is Timestamp
              ? (remoteData[field] as Timestamp).toDate()
              : DateTime.parse(remoteData[field].toString());
          
          mergedData[field] = localTimestamp.isAfter(remoteTimestamp)
              ? localData[field]
              : remoteData[field];
        } else {
          // For other fields, prefer the local data (offline changes)
          mergedData[field] = localData[field];
        }
      }
    }
    
    return mergedData;
  }
}
