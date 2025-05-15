import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

import '../../../../config/app_config.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../../core/services/firebase_service.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../../../core/utils/sync_utils.dart';
import '../models/student_model.dart';

final studentRepositoryProvider = Provider<StudentRepository>((ref) {
  return StudentRepository();
});

/// Repository for handling student data operations
class StudentRepository {
  /// Get all students
  Future<List<StudentModel>> getAllStudents({
    String? schoolId,
    String? classId,
    bool includeInactive = false,
  }) async {
    try {
      // Query local storage first
      final box = LocalStorageService.studentBox;
      final studentsData = LocalStorageService.getAllItems(box);
      
      // Filter data based on parameters
      final filteredData = studentsData.where((data) {
        // Skip deleted items
        if (data['isDeleted'] == true) return false;
        
        // Filter by school
        if (schoolId != null && data['schoolId'] != schoolId) return false;
        
        // Filter by class
        if (classId != null && data['classId'] != classId) return false;
        
        // Filter by active status
        if (!includeInactive && data['isActive'] == false) return false;
        
        return true;
      }).toList();
      
      // Convert to models
      final students = filteredData.map((data) => StudentModel.fromMap(data)).toList();
      
      // Sort by class and name
      students.sort((a, b) {
        final classCompare = a.className.compareTo(b.className);
        if (classCompare != 0) return classCompare;
        
        final sectionCompare = a.section.compareTo(b.section);
        if (sectionCompare != 0) return sectionCompare;
        
        return a.fullName.compareTo(b.fullName);
      });
      
      return students;
    } catch (e) {
      debugPrint('Error getting all students: $e');
      return [];
    }
  }

  /// Get student by ID
  Future<StudentModel?> getStudentById(String id) async {
    try {
      // Try to get from local storage first
      final box = LocalStorageService.studentBox;
      final studentData = LocalStorageService.getItemById(box, id);
      
      if (studentData != null && studentData['isDeleted'] != true) {
        return StudentModel.fromMap(studentData);
      }
      
      // If not in local storage, try to get from Firestore
      // Only do this if there's an internet connection
      final isConnected = await SyncUtils.checkConnectivity();
      if (isConnected) {
        final doc = await FirebaseService.getDocument(
          collection: AppConfig.studentsCollection,
          documentId: id,
        );
        
        if (doc.exists && doc.data() != null) {
          final studentData = doc.data()!;
          
          // Add ID to the data if it's not there
          if (!studentData.containsKey('id')) {
            studentData['id'] = id;
          }
          
          // Save to local storage
          await LocalStorageService.saveItem(box, id, studentData);
          
          // Update sync status to completed
          await LocalStorageService.updateSyncStatus(
            box,
            id,
            SyncStatus.synced,
          );
          
          return StudentModel.fromMap(studentData);
        }
      }
      
      return null;
    } catch (e) {
      debugPrint('Error getting student by ID: $e');
      return null;
    }
  }

  /// Create a new student
  Future<StudentModel?> createStudent(StudentModel student) async {
    try {
      // Generate ID if not provided
      final id = student.id.isEmpty 
          ? LocalStorageService.generateId() 
          : student.id;
      
      // Update student model with generated ID
      final newStudent = student.copyWith(
        id: id,
        createdAt: DateTime.now(),
        lastUpdated: DateTime.now(),
      );
      
      // Save to local storage
      await LocalStorageService.saveItem(
        LocalStorageService.studentBox,
        id,
        newStudent.toMap(),
      );
      
      return newStudent;
    } catch (e) {
      debugPrint('Error creating student: $e');
      return null;
    }
  }

  /// Update a student
  Future<StudentModel?> updateStudent(StudentModel student) async {
    try {
      // Update the last updated timestamp
      final updatedStudent = student.copyWith(
        lastUpdated: DateTime.now(),
      );
      
      // Save to local storage
      await LocalStorageService.saveItem(
        LocalStorageService.studentBox,
        student.id,
        updatedStudent.toMap(),
      );
      
      return updatedStudent;
    } catch (e) {
      debugPrint('Error updating student: $e');
      return null;
    }
  }

  /// Delete a student
  Future<bool> deleteStudent(String id) async {
    try {
      // Mark as deleted in local storage
      await LocalStorageService.deleteItem(
        LocalStorageService.studentBox,
        id,
      );
      
      return true;
    } catch (e) {
      debugPrint('Error deleting student: $e');
      return false;
    }
  }

  /// Search students
  Future<List<StudentModel>> searchStudents(String query, {String? schoolId}) async {
    try {
      // Get all students
      final allStudents = await getAllStudents(schoolId: schoolId);
      
      // If query is empty, return all students
      if (query.isEmpty) return allStudents;
      
      // Search by name, class, or roll number
      final lowerQuery = query.toLowerCase();
      return allStudents.where((student) {
        return student.fullName.toLowerCase().contains(lowerQuery) ||
               student.fullClassName.toLowerCase().contains(lowerQuery) ||
               student.rollNumber.toString().contains(lowerQuery);
      }).toList();
    } catch (e) {
      debugPrint('Error searching students: $e');
      return [];
    }
  }
  
  /// Get students for a parent
  Future<List<StudentModel>> getStudentsForParent(String parentUserId) async {
    try {
      // Query local storage
      final box = LocalStorageService.studentBox;
      final students = LocalStorageService.queryItems(
        box,
        condition: (item) {
          final parentUserIds = item['parentUserIds'];
          if (parentUserIds == null) return false;
          
          // Check if the parent ID is in the list
          if (parentUserIds is List) {
            return parentUserIds.contains(parentUserId);
          }
          return false;
        },
      );
      
      // Convert to models
      return students.map((data) => StudentModel.fromMap(data)).toList();
    } catch (e) {
      debugPrint('Error getting students for parent: $e');
      return [];
    }
  }
  
  /// Count students by class
  Future<Map<String, int>> countStudentsByClass({String? schoolId}) async {
    try {
      // Get all students
      final allStudents = await getAllStudents(schoolId: schoolId, includeInactive: false);
      
      // Count by class
      final countMap = <String, int>{};
      for (final student in allStudents) {
        final classKey = student.fullClassName;
        countMap[classKey] = (countMap[classKey] ?? 0) + 1;
      }
      
      return countMap;
    } catch (e) {
      debugPrint('Error counting students by class: $e');
      return {};
    }
  }
  
  /// Sync students with server
  Future<void> syncStudents() async {
    try {
      await SyncUtils.fullSync();
    } catch (e) {
      debugPrint('Error syncing students: $e');
    }
  }
}
