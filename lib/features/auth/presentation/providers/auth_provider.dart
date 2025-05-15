import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/enums/app_enums.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';

final authControllerProvider = StateNotifierProvider<AuthController, AsyncValue<UserModel?>>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthController(authRepository);
});

/// Controller for handling authentication operations
class AuthController extends StateNotifier<AsyncValue<UserModel?>> {
  final AuthRepository _authRepository;

  AuthController(this._authRepository) : super(const AsyncValue.loading());

  /// Sign in with email and password
  Future<void> signIn({
    required String email, 
    required String password,
  }) async {
    state = const AsyncValue.loading();
    
    try {
      final user = await _authRepository.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      state = AsyncValue.data(user);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      throw e;
    }
  }

  /// Register a new user
  Future<void> register({
    required String email,
    required String password,
    required String fullName,
    required UserRole role,
    String? schoolId,
  }) async {
    state = const AsyncValue.loading();
    
    try {
      final user = await _authRepository.registerWithEmailAndPassword(
        email: email,
        password: password,
        fullName: fullName,
        role: role,
        schoolId: schoolId,
      );
      
      state = AsyncValue.data(user);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      throw e;
    }
  }

  /// Sign out the current user
  Future<void> signOut() async {
    try {
      await _authRepository.signOut();
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      throw e;
    }
  }

  /// Reset user password
  Future<void> resetPassword(String email) async {
    try {
      await _authRepository.resetPassword(email);
    } catch (e) {
      throw e;
    }
  }

  /// Update user profile
  Future<void> updateUserProfile({
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
      final updatedUser = await _authRepository.updateUserProfile(
        uid: uid,
        fullName: fullName,
        phoneNumber: phoneNumber,
        profileImageUrl: profileImageUrl,
        schoolId: schoolId,
        assignedClasses: assignedClasses,
        children: children,
        hasCompletedOnboarding: hasCompletedOnboarding,
      );
      
      state = AsyncValue.data(updatedUser);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      throw e;
    }
  }
  
  /// Check if the user has completed onboarding
  Future<bool> hasCompletedOnboarding(String uid) async {
    try {
      final user = await _authRepository.getUserDetails(uid);
      return user?.hasCompletedOnboarding ?? false;
    } catch (e) {
      return false;
    }
  }
  
  /// Complete the onboarding process
  Future<void> completeOnboarding(String uid) async {
    try {
      await updateUserProfile(
        uid: uid,
        hasCompletedOnboarding: true,
      );
    } catch (e) {
      throw e;
    }
  }
}
