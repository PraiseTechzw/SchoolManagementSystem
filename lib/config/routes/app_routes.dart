import 'package:flutter/material.dart';

/// Class containing all application route names for navigation
class AppRoutes {
  /// Auth routes
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String verifyEmail = '/verify-email';
  static const String verifyPhone = '/verify-phone';
  
  /// Main app routes
  static const String home = '/home';
  static const String dashboard = '/dashboard';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String notifications = '/notifications';
  static const String about = '/about';
  static const String help = '/help';
  
  /// Students routes
  static const String studentsList = '/students';
  static const String studentDetails = '/students/details';
  static const String addEditStudent = '/students/edit';
  static const String studentProfile = '/students/profile';
  
  /// Teachers routes
  static const String teachersList = '/teachers';
  static const String teacherDetails = '/teachers/details';
  static const String addEditTeacher = '/teachers/edit';
  static const String teacherProfile = '/teachers/profile';
  
  /// Classes routes
  static const String classesList = '/classes';
  static const String classDetails = '/classes/details';
  static const String addEditClass = '/classes/edit';
  
  /// Subjects routes
  static const String subjectsList = '/subjects';
  static const String subjectDetails = '/subjects/details';
  static const String addEditSubject = '/subjects/edit';
  
  /// Attendance routes
  static const String attendanceList = '/attendance';
  static const String attendanceDetails = '/attendance/details';
  static const String recordAttendance = '/attendance/record';
  static const String attendanceReport = '/attendance/report';
  
  /// Fees routes
  static const String feesList = '/fees';
  static const String feeDetails = '/fees/details';
  static const String addEditFee = '/fees/edit';
  static const String receipt = '/fees/receipt';
  static const String feesReport = '/fees/report';
  
  /// Grades routes
  static const String gradesList = '/grades';
  static const String gradeDetails = '/grades/details';
  static const String addEditGrade = '/grades/edit';
  static const String reportCard = '/grades/report-card';
  static const String transcripts = '/grades/transcripts';
  
  /// Timetable routes
  static const String timetableList = '/timetable';
  static const String timetableDetails = '/timetable/details';
  static const String addEditTimetable = '/timetable/edit';
  
  /// Events routes
  static const String eventsList = '/events';
  static const String eventDetails = '/events/details';
  static const String addEditEvent = '/events/edit';
  static const String calendar = '/events/calendar';
  
  /// Communication routes
  static const String messagesList = '/messages';
  static const String messageDetails = '/messages/details';
  static const String composeMessage = '/messages/compose';
  static const String announcementsList = '/announcements';
  static const String announcementDetails = '/announcements/details';
  static const String createAnnouncement = '/announcements/create';
  
  /// Library routes
  static const String libraryItems = '/library';
  static const String bookDetails = '/library/book';
  static const String addEditBook = '/library/book/edit';
  static const String borrowings = '/library/borrowings';
  static const String addEditBorrowing = '/library/borrowings/edit';
  
  /// Inventory routes
  static const String inventory = '/inventory';
  static const String inventoryDetails = '/inventory/details';
  static const String addEditInventory = '/inventory/edit';
  
  /// Reports routes
  static const String reports = '/reports';
  static const String reportDetails = '/reports/details';
  static const String createReport = '/reports/create';
  static const String financialReports = '/reports/financial';
  static const String academicReports = '/reports/academic';
  static const String attendanceReports = '/reports/attendance';
  
  /// Admin routes
  static const String adminPanel = '/admin';
  static const String userManagement = '/admin/users';
  static const String schoolSettings = '/admin/settings';
  static const String dataManagement = '/admin/data';
  static const String backupRestore = '/admin/backup';
  static const String systemLogs = '/admin/logs';

  /// Generate routes for the application
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    // Default route handling - this will need to be updated with actual screens
    return MaterialPageRoute(
      builder: (_) => const Scaffold(
        body: Center(
          child: Text('Route not implemented yet'),
        ),
      ),
    );
  }
}