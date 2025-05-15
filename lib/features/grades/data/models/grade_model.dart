import 'package:cloud_firestore/cloud_firestore.dart';

/// Model class for student grades/assessment results
class GradeModel {
  final String id;
  final String studentId;
  final String classId;
  final String subject;
  final String type; // Quiz, Assignment, Midterm, Final etc.
  final double score;
  final double totalPossible;
  final String? teacherRemarks;
  final DateTime date;
  final String termId;
  final String yearId;
  final String teacherId;
  
  /// Constructor
  GradeModel({
    required this.id,
    required this.studentId,
    required this.classId,
    required this.subject,
    required this.type,
    required this.score,
    required this.totalPossible,
    this.teacherRemarks,
    required this.date,
    required this.termId,
    required this.yearId,
    required this.teacherId,
  });
  
  /// Create from map
  factory GradeModel.fromMap(Map<String, dynamic> map) {
    return GradeModel(
      id: map['id'] as String,
      studentId: map['studentId'] as String,
      classId: map['classId'] as String,
      subject: map['subject'] as String,
      type: map['type'] as String,
      score: (map['score'] as num).toDouble(),
      totalPossible: (map['totalPossible'] as num).toDouble(),
      teacherRemarks: map['teacherRemarks'] as String?,
      date: (map['date'] as Timestamp).toDate(),
      termId: map['termId'] as String,
      yearId: map['yearId'] as String,
      teacherId: map['teacherId'] as String,
    );
  }
  
  /// Convert to map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'studentId': studentId,
      'classId': classId,
      'subject': subject,
      'type': type,
      'score': score,
      'totalPossible': totalPossible,
      'teacherRemarks': teacherRemarks,
      'date': date,
      'termId': termId,
      'yearId': yearId,
      'teacherId': teacherId,
    };
  }
  
  /// Create a copy of this grade with modified fields
  GradeModel copyWith({
    String? id,
    String? studentId,
    String? classId,
    String? subject,
    String? type,
    double? score,
    double? totalPossible,
    String? teacherRemarks,
    DateTime? date,
    String? termId,
    String? yearId,
    String? teacherId,
  }) {
    return GradeModel(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      classId: classId ?? this.classId,
      subject: subject ?? this.subject,
      type: type ?? this.type,
      score: score ?? this.score,
      totalPossible: totalPossible ?? this.totalPossible,
      teacherRemarks: teacherRemarks ?? this.teacherRemarks,
      date: date ?? this.date,
      termId: termId ?? this.termId,
      yearId: yearId ?? this.yearId,
      teacherId: teacherId ?? this.teacherId,
    );
  }
} 