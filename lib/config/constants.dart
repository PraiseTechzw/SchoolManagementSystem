import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryColor = Color(0xFF2E7D32);
  static const Color secondaryColor = Color(0xFF388E3C);
  static const Color accentColor = Color(0xFF4CAF50);
  
  static const Color primaryColorDark = Color(0xFF1B5E20);
  static const Color secondaryColorDark = Color(0xFF2E7D32);
  static const Color accentColorDark = Color(0xFF388E3C);
  
  static const Color syncCompletedColor = Color(0xFF43A047);
  static const Color syncPendingColor = Color(0xFFFFA000);
  static const Color syncErrorColor = Color(0xFFD32F2F);
  
  static const Color usdColor = Color(0xFF1565C0);
  static const Color zwlColor = Color(0xFF6A1B9A);
}

class AppAssets {
  static const String logo = 'assets/images/logo.svg';
  static const String loginBackground = 'assets/images/login_background.svg';
  static const String noConnection = 'assets/images/no_connection.svg';
  static const String emptyState = 'assets/images/empty_state.svg';
  static const String error = 'assets/images/error.svg';
  static const String success = 'assets/images/success.svg';
}

class AppStrings {
  static const String appName = 'ChikoroPro';
  static const String appTagline = 'Smart School Management System';
  
  // Login Screen
  static const String login = 'Login';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String forgotPassword = 'Forgot Password?';
  static const String noAccount = 'Don\'t have an account?';
  static const String register = 'Register';
  
  // Register Screen
  static const String createAccount = 'Create Account';
  static const String fullName = 'Full Name';
  static const String confirmPassword = 'Confirm Password';
  static const String role = 'Role';
  static const String hasAccount = 'Already have an account?';
  
  // Dashboard
  static const String dashboard = 'Dashboard';
  static const String students = 'Students';
  static const String classes = 'Classes';
  static const String attendance = 'Attendance';
  static const String fees = 'Fees';
  static const String payments = 'Payments';
  static const String grades = 'Grades';
  static const String reports = 'Reports';
  static const String announcements = 'Announcements';
  static const String settings = 'Settings';
  static const String logout = 'Logout';
  
  // Sync Status
  static const String syncCompleted = 'Sync Completed';
  static const String syncPending = 'Sync Pending';
  static const String syncError = 'Sync Error';
  static const String offline = 'Offline';
  static const String online = 'Online';
  
  // Student
  static const String addStudent = 'Add Student';
  static const String editStudent = 'Edit Student';
  static const String studentDetails = 'Student Details';
  static const String studentId = 'Student ID';
  static const String dateOfBirth = 'Date of Birth';
  static const String gender = 'Gender';
  static const String address = 'Address';
  static const String contactPerson = 'Contact Person';
  static const String contactNumber = 'Contact Number';
  
  // Fees
  static const String addPayment = 'Add Payment';
  static const String paymentDetails = 'Payment Details';
  static const String amount = 'Amount';
  static const String paymentDate = 'Payment Date';
  static const String paymentMethod = 'Payment Method';
  static const String reference = 'Reference';
  static const String currency = 'Currency';
  static const String balance = 'Balance';
  static const String receipt = 'Receipt';
  
  // Attendance
  static const String markAttendance = 'Mark Attendance';
  static const String present = 'Present';
  static const String absent = 'Absent';
  static const String late = 'Late';
  static const String excused = 'Excused';
  
  // Grades
  static const String enterGrades = 'Enter Grades';
  static const String subject = 'Subject';
  static const String term = 'Term';
  static const String grade = 'Grade';
  static const String comment = 'Comment';
  static const String reportCard = 'Report Card';
  
  // Announcements
  static const String addAnnouncement = 'Add Announcement';
  static const String title = 'Title';
  static const String message = 'Message';
  static const String date = 'Date';
  static const String audience = 'Audience';
  
  // Settings
  static const String language = 'Language';
  static const String theme = 'Theme';
  static const String notification = 'Notification';
  static const String backup = 'Backup';
  static const String restore = 'Restore';
  static const String about = 'About';
  
  // Common
  static const String save = 'Save';
  static const String cancel = 'Cancel';
  static const String delete = 'Delete';
  static const String edit = 'Edit';
  static const String view = 'View';
  static const String search = 'Search';
  static const String filter = 'Filter';
  static const String sort = 'Sort';
  static const String export = 'Export';
  static const String import = 'Import';
  static const String print = 'Print';
  static const String share = 'Share';
  static const String send = 'Send';
  static const String yes = 'Yes';
  static const String no = 'No';
  static const String ok = 'OK';
  static const String done = 'Done';
  static const String next = 'Next';
  static const String previous = 'Previous';
  static const String loading = 'Loading...';
  static const String noData = 'No Data Available';
  static const String error = 'Error';
  static const String success = 'Success';
  static const String warning = 'Warning';
  static const String info = 'Information';
  static const String confirmation = 'Confirmation';
  static const String areYouSure = 'Are you sure?';
  static const String cannotBeUndone = 'This action cannot be undone.';
}

class AppDimens {
  static const double borderRadius = 8.0;
  static const double cardElevation = 2.0;
  static const double padding = 16.0;
  static const double margin = 16.0;
  static const double iconSize = 24.0;
  static const double avatarSize = 40.0;
  static const double logoSize = 100.0;
}
