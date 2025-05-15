import 'dart:convert';

import '../../../../core/enums/app_enums.dart';

/// User model representing a user in the system
class UserModel {
  final String id;
  final String email;
  final String fullName;
  final String role;
  final String? phoneNumber;
  final String? profileImageUrl;
  final String? schoolId;
  final List<String>? assignedClasses;
  final List<String>? children;
  final bool isActive;
  final bool hasCompletedOnboarding;
  final DateTime createdAt;
  final DateTime lastUpdated;

  UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    required this.role,
    this.phoneNumber,
    this.profileImageUrl,
    this.schoolId,
    this.assignedClasses,
    this.children,
    this.isActive = true,
    this.hasCompletedOnboarding = false,
    DateTime? createdAt,
    DateTime? lastUpdated,
  }) : 
    createdAt = createdAt ?? DateTime.now(),
    lastUpdated = lastUpdated ?? DateTime.now();

  /// Create a copy of this user with the given fields replaced
  UserModel copyWith({
    String? id,
    String? email,
    String? fullName,
    String? role,
    String? phoneNumber,
    String? profileImageUrl,
    String? schoolId,
    List<String>? assignedClasses,
    List<String>? children,
    bool? isActive,
    bool? hasCompletedOnboarding,
    DateTime? createdAt,
    DateTime? lastUpdated,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      role: role ?? this.role,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      schoolId: schoolId ?? this.schoolId,
      assignedClasses: assignedClasses ?? this.assignedClasses,
      children: children ?? this.children,
      isActive: isActive ?? this.isActive,
      hasCompletedOnboarding: hasCompletedOnboarding ?? this.hasCompletedOnboarding,
      createdAt: createdAt ?? this.createdAt,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  /// Convert user to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'role': role,
      'phoneNumber': phoneNumber,
      'profileImageUrl': profileImageUrl,
      'schoolId': schoolId,
      'assignedClasses': assignedClasses,
      'children': children,
      'isActive': isActive,
      'hasCompletedOnboarding': hasCompletedOnboarding,
      'createdAt': createdAt.toIso8601String(),
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  /// Create a user from a map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      fullName: map['fullName'] ?? '',
      role: map['role'] ?? UserRole.student.toString(),
      phoneNumber: map['phoneNumber'],
      profileImageUrl: map['profileImageUrl'],
      schoolId: map['schoolId'],
      assignedClasses: map['assignedClasses'] != null 
          ? List<String>.from(map['assignedClasses']) 
          : null,
      children: map['children'] != null 
          ? List<String>.from(map['children']) 
          : null,
      isActive: map['isActive'] ?? true,
      hasCompletedOnboarding: map['hasCompletedOnboarding'] ?? false,
      createdAt: map['createdAt'] != null 
          ? DateTime.parse(map['createdAt']) 
          : DateTime.now(),
      lastUpdated: map['lastUpdated'] != null 
          ? DateTime.parse(map['lastUpdated']) 
          : DateTime.now(),
    );
  }

  /// Convert user to JSON
  String toJson() => json.encode(toMap());

  /// Create a user from JSON
  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));

  /// Create an empty user
  factory UserModel.empty() {
    return UserModel(
      id: '',
      email: '',
      fullName: '',
      role: UserRole.student.toString(),
    );
  }

  /// Check if this is an admin user
  bool get isAdmin => role == UserRole.admin.toString();

  /// Check if this is a clerk user
  bool get isClerk => role == UserRole.clerk.toString();

  /// Check if this is a teacher user
  bool get isTeacher => role == UserRole.teacher.toString();

  /// Check if this is a parent user
  bool get isParent => role == UserRole.parent.toString();

  /// Check if this is a student user
  bool get isStudent => role == UserRole.student.toString();

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, fullName: $fullName, role: $role)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is UserModel &&
      other.id == id &&
      other.email == email &&
      other.fullName == fullName &&
      other.role == role &&
      other.phoneNumber == phoneNumber &&
      other.profileImageUrl == profileImageUrl &&
      other.schoolId == schoolId &&
      other.isActive == isActive &&
      other.hasCompletedOnboarding == hasCompletedOnboarding;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      email.hashCode ^
      fullName.hashCode ^
      role.hashCode ^
      phoneNumber.hashCode ^
      profileImageUrl.hashCode ^
      schoolId.hashCode ^
      isActive.hashCode ^
      hasCompletedOnboarding.hashCode;
  }
}
