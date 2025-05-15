import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../enums/app_enums.dart';
import '../services/firebase_service.dart';
import '../../features/auth/data/models/user_model.dart';
import '../../features/auth/data/repositories/auth_repository.dart';

/// Provider for the authentication state stream
final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseService.auth.authStateChanges();
});

/// Provider for the currently authenticated user information
final currentUserProvider = FutureProvider<UserModel?>((ref) async {
  final user = FirebaseService.currentUser;
  if (user == null) return null;
  
  final authRepository = ref.watch(authRepositoryProvider);
  return await authRepository.getUserDetails(user.uid);
});

/// Provider for the user's role
final userRoleProvider = FutureProvider<String>((ref) async {
  final user = FirebaseService.currentUser;
  if (user == null) return '';
  
  final userRole = await FirebaseService.getUserRole(user.uid);
  return userRole.toString();
});

/// Provider for checking if the user has completed onboarding
final hasCompletedOnboardingProvider = StateProvider<bool>((ref) {
  final uid = FirebaseService.currentUser?.uid;
  if (uid == null) return false;
  
  // Check if user has completed onboarding
  final result = ref.watch(currentUserProvider);
  return result.whenOrNull(
    data: (user) => user?.hasCompletedOnboarding ?? false,
  ) ?? false;
});

/// Check if user has admin privileges
final isAdminProvider = Provider<bool>((ref) {
  final roleAsync = ref.watch(userRoleProvider);
  return roleAsync.whenOrNull(
    data: (role) => role == UserRole.admin.toString(),
  ) ?? false;
});

/// Check if user has clerk privileges
final isClerkProvider = Provider<bool>((ref) {
  final roleAsync = ref.watch(userRoleProvider);
  return roleAsync.whenOrNull(
    data: (role) => role == UserRole.clerk.toString() || role == UserRole.admin.toString(),
  ) ?? false;
});

/// Check if user has teacher privileges
final isTeacherProvider = Provider<bool>((ref) {
  final roleAsync = ref.watch(userRoleProvider);
  return roleAsync.whenOrNull(
    data: (role) => role == UserRole.teacher.toString() || role == UserRole.admin.toString(),
  ) ?? false;
});

/// Check if user has parent privileges
final isParentProvider = Provider<bool>((ref) {
  final roleAsync = ref.watch(userRoleProvider);
  return roleAsync.whenOrNull(
    data: (role) => role == UserRole.parent.toString(),
  ) ?? false;
});

/// Check if user has student privileges
final isStudentProvider = Provider<bool>((ref) {
  final roleAsync = ref.watch(userRoleProvider);
  return roleAsync.whenOrNull(
    data: (role) => role == UserRole.student.toString(),
  ) ?? false;
});
