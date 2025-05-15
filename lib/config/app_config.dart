import 'package:flutter/material.dart';

import '../core/enums/app_enums.dart';

/// Application-wide configuration settings
class AppConfig {
  /// App name
  static const String appName = 'ChikoroPro';
  
  /// App version
  static const String appVersion = '1.0.0';
  
  /// Default language
  static const AppLanguage defaultLanguage = AppLanguage.english;
  
  /// Default theme
  static const AppTheme defaultTheme = AppTheme.light;
  
  /// API base URL
  static const String apiBaseUrl = 'https://api.chikoropro.com';
  
  /// SMS API base URL (Africa's Talking)
  static const String smsApiBaseUrl = 'https://api.africastalking.com';
  
  /// Offline sync interval in minutes
  static const int syncIntervalMinutes = 30;
  
  /// Maximum upload file size in MB
  static const int maxUploadSizeMB = 10;
  
  /// Default pagination limit
  static const int defaultPaginationLimit = 20;
  
  /// Session timeout in minutes
  static const int sessionTimeoutMinutes = 30;
  
  /// Main color palette
  static const Color primaryColor = Color(0xFF2196F3);
  static const Color primaryColorLight = Color(0xFF64B5F6);
  static const Color primaryColorDark = Color(0xFF1976D2);
  static const Color accentColor = Color(0xFF4CAF50);
  static const Color errorColor = Color(0xFFE57373);
  
  /// Light theme colors
  static const Color lightBackgroundColor = Color(0xFFF5F5F5);
  static const Color lightCardColor = Color(0xFFFFFFFF);
  static const Color lightTextColor = Color(0xFF212121);
  static const Color lightSecondaryTextColor = Color(0xFF757575);
  
  /// Dark theme colors
  static const Color darkBackgroundColor = Color(0xFF121212);
  static const Color darkCardColor = Color(0xFF1E1E1E);
  static const Color darkTextColor = Color(0xFFEEEEEE);
  static const Color darkSecondaryTextColor = Color(0xFFAAAAAA);
  
  /// Fonts
  static const String primaryFontFamily = 'Roboto';
  static const String secondaryFontFamily = 'Poppins';
  
  /// Default border radius
  static const double defaultBorderRadius = 8.0;
  
  /// Default padding
  static const double defaultPadding = 16.0;
  
  /// Default elevation
  static const double defaultElevation = 2.0;
  
  /// Default animation duration
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  
  /// Features flags
  static const bool enableOfflineMode = true;
  static const bool enablePushNotifications = true;
  static const bool enableSmsNotifications = true;
  static const bool enableMultiLanguage = true;
  static const bool enableDarkMode = true;
  static const bool enableDataExport = true;
  static const bool enableBackupRestore = true;
  
  /// File storage paths
  static const String imagePath = 'images';
  static const String documentsPath = 'documents';
  static const String cachePath = 'cache';
  static const String tempPath = 'temp';
  
  /// Security settings
  static const bool enforceStrongPasswords = true;
  static const int minimumPasswordLength = 8;
  static const int passwordExpiryDays = 90;
  static const bool requireBiometricAuth = false;
  
  /// App store URLs
  static const String androidStoreUrl = 'https://play.google.com/store/apps/details?id=com.chikoropro.app';
  static const String iosStoreUrl = 'https://apps.apple.com/app/chikoropro/id1234567890';
  
  /// Support contact info
  static const String supportEmail = 'support@chikoropro.com';
  static const String supportPhone = '+263 77 123 4567';
  static const String supportWebsite = 'https://chikoropro.com/support';
  
  /// Firebase collection names
  static const String usersCollection = 'users';
  static const String schoolsCollection = 'schools';
  static const String classesCollection = 'classes';
  static const String studentsCollection = 'students';
  static const String teachersCollection = 'teachers';
  static const String subjectsCollection = 'subjects';
  static const String gradesCollection = 'grades';
  static const String attendanceCollection = 'attendance';
  static const String feesCollection = 'fees';
  static const String paymentsCollection = 'payments';
  static const String announcementsCollection = 'announcements';
  
  /// Hive box names
  static const String userBox = 'user_box';
  static const String studentBox = 'student_box';
  static const String classBox = 'class_box';
  static const String paymentBox = 'payment_box';
  static const String attendanceBox = 'attendance_box';
  static const String gradeBox = 'grade_box';
  static const String announcementBox = 'announcement_box';
  static const String schoolBox = 'school_box';
  static const String settingsBox = 'settings_box';
}