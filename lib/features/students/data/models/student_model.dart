import 'dart:convert';

import '../../../../core/enums/app_enums.dart';

/// Student model representing a student in the system
class StudentModel {
  final String id;
  final String schoolId;
  final String firstName;
  final String lastName;
  final String? middleName;
  final DateTime dateOfBirth;
  final Gender gender;
  final String? address;
  final String classId;
  final String className;
  final String section;
  final int rollNumber;
  final String? guardianName;
  final String? guardianPhone;
  final String? guardianEmail;
  final String? guardianRelation;
  final List<String>? parentUserIds;
  final String? profilePhotoUrl;
  final DateTime admissionDate;
  final bool isActive;
  final Map<String, dynamic>? additionalInfo;
  final DateTime createdAt;
  final DateTime lastUpdated;
  final String? syncStatus;

  StudentModel({
    required this.id,
    required this.schoolId,
    required this.firstName,
    required this.lastName,
    this.middleName,
    required this.dateOfBirth,
    required this.gender,
    this.address,
    required this.classId,
    required this.className,
    required this.section,
    required this.rollNumber,
    this.guardianName,
    this.guardianPhone,
    this.guardianEmail,
    this.guardianRelation,
    this.parentUserIds,
    this.profilePhotoUrl,
    required this.admissionDate,
    this.isActive = true,
    this.additionalInfo,
    DateTime? createdAt,
    DateTime? lastUpdated,
    this.syncStatus,
  }) : 
    createdAt = createdAt ?? DateTime.now(),
    lastUpdated = lastUpdated ?? DateTime.now();

  /// Create a copy of this student with the given fields replaced
  StudentModel copyWith({
    String? id,
    String? schoolId,
    String? firstName,
    String? lastName,
    String? middleName,
    DateTime? dateOfBirth,
    Gender? gender,
    String? address,
    String? classId,
    String? className,
    String? section,
    int? rollNumber,
    String? guardianName,
    String? guardianPhone,
    String? guardianEmail,
    String? guardianRelation,
    List<String>? parentUserIds,
    String? profilePhotoUrl,
    DateTime? admissionDate,
    bool? isActive,
    Map<String, dynamic>? additionalInfo,
    DateTime? createdAt,
    DateTime? lastUpdated,
    String? syncStatus,
  }) {
    return StudentModel(
      id: id ?? this.id,
      schoolId: schoolId ?? this.schoolId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      middleName: middleName ?? this.middleName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      address: address ?? this.address,
      classId: classId ?? this.classId,
      className: className ?? this.className,
      section: section ?? this.section,
      rollNumber: rollNumber ?? this.rollNumber,
      guardianName: guardianName ?? this.guardianName,
      guardianPhone: guardianPhone ?? this.guardianPhone,
      guardianEmail: guardianEmail ?? this.guardianEmail,
      guardianRelation: guardianRelation ?? this.guardianRelation,
      parentUserIds: parentUserIds ?? this.parentUserIds,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      admissionDate: admissionDate ?? this.admissionDate,
      isActive: isActive ?? this.isActive,
      additionalInfo: additionalInfo ?? this.additionalInfo,
      createdAt: createdAt ?? this.createdAt,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }

  /// Convert student to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'schoolId': schoolId,
      'firstName': firstName,
      'lastName': lastName,
      'middleName': middleName,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'gender': gender.toString(),
      'address': address,
      'classId': classId,
      'className': className,
      'section': section,
      'rollNumber': rollNumber,
      'guardianName': guardianName,
      'guardianPhone': guardianPhone,
      'guardianEmail': guardianEmail,
      'guardianRelation': guardianRelation,
      'parentUserIds': parentUserIds,
      'profilePhotoUrl': profilePhotoUrl,
      'admissionDate': admissionDate.toIso8601String(),
      'isActive': isActive,
      'additionalInfo': additionalInfo,
      'createdAt': createdAt.toIso8601String(),
      'lastUpdated': lastUpdated.toIso8601String(),
      'syncStatus': syncStatus,
    };
  }

  /// Create a student from a map
  factory StudentModel.fromMap(Map<String, dynamic> map) {
    return StudentModel(
      id: map['id'] ?? '',
      schoolId: map['schoolId'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      middleName: map['middleName'],
      dateOfBirth: map['dateOfBirth'] != null 
          ? DateTime.parse(map['dateOfBirth']) 
          : DateTime.now(),
      gender: map['gender'] != null 
          ? GenderExtension.fromString(map['gender']) 
          : Gender.other,
      address: map['address'],
      classId: map['classId'] ?? '',
      className: map['className'] ?? '',
      section: map['section'] ?? '',
      rollNumber: map['rollNumber'] ?? 0,
      guardianName: map['guardianName'],
      guardianPhone: map['guardianPhone'],
      guardianEmail: map['guardianEmail'],
      guardianRelation: map['guardianRelation'],
      parentUserIds: map['parentUserIds'] != null 
          ? List<String>.from(map['parentUserIds']) 
          : null,
      profilePhotoUrl: map['profilePhotoUrl'],
      admissionDate: map['admissionDate'] != null 
          ? DateTime.parse(map['admissionDate']) 
          : DateTime.now(),
      isActive: map['isActive'] ?? true,
      additionalInfo: map['additionalInfo'],
      createdAt: map['createdAt'] != null 
          ? DateTime.parse(map['createdAt']) 
          : DateTime.now(),
      lastUpdated: map['lastUpdated'] != null 
          ? DateTime.parse(map['lastUpdated']) 
          : DateTime.now(),
      syncStatus: map['syncStatus'],
    );
  }

  /// Convert student to JSON
  String toJson() => json.encode(toMap());

  /// Create a student from JSON
  factory StudentModel.fromJson(String source) => StudentModel.fromMap(json.decode(source));

  /// Get full name
  String get fullName {
    if (middleName != null && middleName!.isNotEmpty) {
      return '$firstName $middleName $lastName';
    }
    return '$firstName $lastName';
  }

  /// Get age
  int get age {
    final today = DateTime.now();
    int age = today.year - dateOfBirth.year;
    
    // Adjust age if birthday hasn't occurred yet this year
    if (today.month < dateOfBirth.month || 
        (today.month == dateOfBirth.month && today.day < dateOfBirth.day)) {
      age--;
    }
    
    return age;
  }

  /// Get full class name with section
  String get fullClassName => '$className-$section';

  @override
  String toString() {
    return 'StudentModel(id: $id, fullName: $fullName, className: $className, section: $section)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is StudentModel &&
      other.id == id &&
      other.schoolId == schoolId &&
      other.firstName == firstName &&
      other.lastName == lastName &&
      other.classId == classId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      schoolId.hashCode ^
      firstName.hashCode ^
      lastName.hashCode ^
      classId.hashCode;
  }
}
