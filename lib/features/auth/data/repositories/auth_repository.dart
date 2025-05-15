import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

import '../../../../config/app_config.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../../core/services/firebase_service.dart';
import '../../../../core/services/local_storage_service.dart';
import '../models/user_model.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

/// Repository for handling authentication related operations
class AuthRepository {
  final FirebaseAuth _auth = FirebaseService.auth;
  
  /// Sign in with email and password
  Future<UserModel?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (userCredential.user != null) {
        final user = await getUserDetails(userCredential.user!.uid);
        if (user != null) {
          await _cacheUserLocally(user);
        }
        return user;
      }
      
      return null;
    } on FirebaseAuthException catch (e) {
      debugPrint('Sign in error: ${e.code}');
      throw _handleAuthException(e);
    }
  }
  
  /// Register a new user
  Future<UserModel?> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String fullName,
    required UserRole role,
    String? schoolId,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (userCredential.user != null) {
        // Create user model
        final newUser = UserModel(
          id: userCredential.user!.uid,
          email: email,
          fullName: fullName,
          role: role.toString(),
          schoolId: schoolId,
          hasCompletedOnboarding: false,
          createdAt: DateTime.now(),
          lastUpdated: DateTime.now(),
        );
        
        // Save to Firestore
        await FirebaseService.saveUserData(newUser);
        
        // Cache locally
        await _cacheUserLocally(newUser);
        
        return newUser;
      }
      
      return null;
    } on FirebaseAuthException catch (e) {
      debugPrint('Registration error: ${e.code}');
      throw _handleAuthException(e);
    }
  }
  
  /// Sign out the current user
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await LocalStorageService.clearAllBoxes();
    } catch (e) {
      debugPrint('Sign out error: $e');
      throw Exception('Could not sign out: $e');
    }
  }
  
  /// Reset user password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      debugPrint('Password reset error: ${e.code}');
      throw _handleAuthException(e);
    }
  }
  
  /// Get user details from Firestore or local cache
  Future<UserModel?> getUserDetails(String uid) async {
    try {
      // Check local storage first
      final localUser = LocalStorageService.getItemById(
        LocalStorageService.userBox, 
        uid,
      );
      
      if (localUser != null) {
        return UserModel.fromMap(localUser);
      }
      
      // Fetch from Firestore if not in local storage
      final doc = await FirebaseService.getDocument(
        collection: AppConfig.usersCollection,
        documentId: uid,
      );
      
      if (doc.exists && doc.data() != null) {
        final userData = doc.data()!;
        
        if (!userData.containsKey('id')) {
          userData['id'] = uid;
        }
        
        final user = UserModel.fromMap(userData);
        
        // Cache user locally
        await _cacheUserLocally(user);
        
        return user;
      }
      
      return null;
    } catch (e) {
      debugPrint('Error getting user details: $e');
      return null;
    }
  }
  
  /// Update user profile
  Future<UserModel?> updateUserProfile({
    required String uid,
    String? fullName,
    String? phoneNumber,
    String? profileImageUrl,
    String? schoolId,
    List<String>? assignedClasses,
    List<String>? children,
    bool? hasCompletedOnboarding,
  }) async {
    try {
      // Get current user data
      final currentUser = await getUserDetails(uid);
      if (currentUser == null) {
        throw Exception('User not found');
      }
      
      // Create updated user
      final updatedUser = currentUser.copyWith(
        fullName: fullName,
        phoneNumber: phoneNumber,
        profileImageUrl: profileImageUrl,
        schoolId: schoolId,
        assignedClasses: assignedClasses,
        children: children,
        hasCompletedOnboarding: hasCompletedOnboarding,
        lastUpdated: DateTime.now(),
      );
      
      // Update in Firestore
      await FirebaseService.updateDocument(
        collection: AppConfig.usersCollection,
        documentId: uid,
        data: updatedUser.toMap(),
      );
      
      // Update local cache
      await _cacheUserLocally(updatedUser);
      
      return updatedUser;
    } catch (e) {
      debugPrint('Error updating user profile: $e');
      throw Exception('Failed to update profile: $e');
    }
  }
  
  /// Cache user data locally
  Future<void> _cacheUserLocally(UserModel user) async {
    await LocalStorageService.saveItem(
      LocalStorageService.userBox,
      user.id,
      user.toMap(),
    );
  }
  
  /// Handle Firebase Auth exceptions
  Exception _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return Exception('No user found with this email.');
      case 'wrong-password':
        return Exception('Wrong password provided.');
      case 'email-already-in-use':
        return Exception('This email is already registered.');
      case 'weak-password':
        return Exception('The password is too weak.');
      case 'invalid-email':
        return Exception('The email address is invalid.');
      case 'user-disabled':
        return Exception('This user account has been disabled.');
      case 'too-many-requests':
        return Exception('Too many requests. Try again later.');
      case 'operation-not-allowed':
        return Exception('This operation is not allowed.');
      case 'network-request-failed':
        return Exception('Network error. Check your connection.');
      default:
        return Exception('Authentication error: ${e.message}');
    }
  }
}
