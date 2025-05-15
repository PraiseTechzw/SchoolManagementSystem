import 'package:flutter/foundation.dart';

/// Configuration class for application-wide settings
class AppConfig {
  static const String appName = 'ChikoroPro';
  static const String appVersion = '1.0.0';
  
  // Firebase collection names
  static const String usersCollection = 'users';
  static const String studentsCollection = 'students';
  static const String classesCollection = 'classes';
  static const String paymentsCollection = 'payments';
  static const String attendanceCollection = 'attendance';
  static const String gradesCollection = 'grades';
  static const String announcementsCollection = 'announcements';
  static const String schoolsCollection = 'schools';
  
  // Hive box names
  static const String userBox = 'user_box';
  static const String studentBox = 'student_box';
  static const String classBox = 'class_box';
  static const String paymentBox = 'payment_box';
  static const String attendanceBox = 'attendance_box';
  static const String gradeBox = 'grade_box';
  static const String announcementBox = 'announcement_box';
  static const String schoolBox = 'school_box';
  static const String settingsBox = 'settings_box';
  
  // Cache TTL in minutes
  static const int cacheTtlMinutes = 60;
  
  // Sync config
  static const int syncIntervalMinutes = 30;
  static const int maxSyncRetries = 5;
  
  // Default currency
  static const String defaultCurrency = 'USD';
  static const List<String> supportedCurrencies = ['USD', 'ZWL'];
  
  // Default language
  static const String defaultLanguage = 'en';
  static const List<String> supportedLanguages = ['en', 'sn', 'nd'];
  
  // Payment types
  static const List<String> paymentTypes = ['Cash', 'Bank Transfer', 'Mobile Money'];
  
  // Grade types
  static const List<String> gradeTypes = ['Quiz', 'Assignment', 'Midterm', 'Final'];
  
  // Pagination limit
  static const int paginationLimit = 20;
  
  // Get a human-readable device type
  static String get deviceType {
    if (kIsWeb) return 'Web';
    if (defaultTargetPlatform == TargetPlatform.android) return 'Android';
    if (defaultTargetPlatform == TargetPlatform.iOS) return 'iOS';
    if (defaultTargetPlatform == TargetPlatform.macOS) return 'macOS';
    if (defaultTargetPlatform == TargetPlatform.windows) return 'Windows';
    if (defaultTargetPlatform == TargetPlatform.linux) return 'Linux';
    return 'Unknown';
  }
  
  // Check if the app is running on a mobile device
  static bool get isMobile => 
      defaultTargetPlatform == TargetPlatform.android || 
      defaultTargetPlatform == TargetPlatform.iOS;
  
  // Check if the app is running on a desktop device
  static bool get isDesktop => 
      defaultTargetPlatform == TargetPlatform.macOS || 
      defaultTargetPlatform == TargetPlatform.windows || 
      defaultTargetPlatform == TargetPlatform.linux;
}
