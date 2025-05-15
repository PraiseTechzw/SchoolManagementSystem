/// Application configuration constants
class AppConfig {
  // App information
  static const String appName = 'ChikoroPro';
  static const String appTagline = 'Smart School Management System';
  static const String appVersion = '1.0.0';
  
  // Firebase collection names
  static const String usersCollection = 'users';
  static const String schoolsCollection = 'schools';
  static const String studentsCollection = 'students';
  static const String classesCollection = 'classes';
  static const String subjectsCollection = 'subjects';
  static const String paymentsCollection = 'payments';
  static const String attendanceCollection = 'attendance';
  static const String gradesCollection = 'grades';
  static const String announcementsCollection = 'announcements';
  
  // Hive box names
  static const String userBox = 'user_box';
  static const String schoolBox = 'school_box';
  static const String studentBox = 'student_box';
  static const String classBox = 'class_box';
  static const String subjectBox = 'subject_box';
  static const String paymentBox = 'payment_box';
  static const String attendanceBox = 'attendance_box';
  static const String gradeBox = 'grade_box';
  static const String announcementBox = 'announcement_box';
  static const String settingsBox = 'settings_box';
  
  // Settings keys
  static const String languageKey = 'language';
  static const String themeKey = 'theme';
  static const String notificationKey = 'notification';
  static const String lastSyncKey = 'last_sync';
  static const String activeSchoolKey = 'active_school';
  static const String activeTermKey = 'active_term';
  static const String academicYearKey = 'academic_year';
  
  // Timeout durations
  static const int connectionTimeout = 30; // seconds
  static const int maxRetryAttempts = 3;
  
  // Fee configuration
  static const double defaultUsdRate = 3500.0; // ZWL to USD exchange rate
  
  // Report configuration
  static const int gradeAThreshold = 80;
  static const int gradeBThreshold = 70;
  static const int gradeCThreshold = 60;
  static const int gradeDThreshold = 50;
  static const int gradeFThreshold = 40;
  
  // App limits
  static const int maxStudentsPerClass = 80;
  static const int maxClassesPerSchool = 50;
  static const int maxSubjectsPerClass = 15;
  static const int maxAttachmentsSize = 10 * 1024 * 1024; // 10 MB
  
  // Sync configuration
  static const int syncIntervalMinutes = 30;
  static const int maxOfflineDays = 30;
  
  // Notification configuration
  static const bool enableSmsNotifications = true;
  static const bool enablePushNotifications = true;
  
  // API endpoints
  static const String smsApiEndpoint = 'https://api.africastalking.com/version1/messaging';
  
  // Default values
  static const String defaultCurrency = 'USD';
  static const String defaultLanguageCode = 'en';
}