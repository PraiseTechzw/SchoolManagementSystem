import 'package:flutter/material.dart';

import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/register_screen.dart';
import '../features/dashboard/presentation/screens/admin_dashboard.dart';
import '../features/dashboard/presentation/screens/clerk_dashboard.dart';
import '../features/dashboard/presentation/screens/teacher_dashboard.dart';
import '../features/dashboard/presentation/screens/parent_dashboard.dart';
import '../features/dashboard/presentation/screens/student_dashboard.dart';
import '../features/students/presentation/screens/student_list_screen.dart';
import '../features/students/presentation/screens/student_detail_screen.dart';
import '../features/fees/presentation/screens/payment_screen.dart';
import '../features/fees/presentation/screens/receipt_screen.dart';
import '../features/attendance/presentation/screens/attendance_screen.dart';
import '../features/grades/presentation/screens/grade_entry_screen.dart';
import '../features/grades/presentation/screens/report_card_screen.dart';

class AppRoutes {
  static const String initial = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String adminDashboard = '/admin';
  static const String clerkDashboard = '/clerk';
  static const String teacherDashboard = '/teacher';
  static const String parentDashboard = '/parent';
  static const String studentDashboard = '/student';
  static const String studentList = '/students';
  static const String studentDetail = '/students/detail';
  static const String payment = '/payment';
  static const String receipt = '/receipt';
  static const String attendance = '/attendance';
  static const String gradeEntry = '/grades/entry';
  static const String reportCard = '/grades/report';
  static const String announcement = '/announcement';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case adminDashboard:
        return MaterialPageRoute(builder: (_) => const AdminDashboard());
      case clerkDashboard:
        return MaterialPageRoute(builder: (_) => const ClerkDashboard());
      case teacherDashboard:
        return MaterialPageRoute(builder: (_) => const TeacherDashboard());
      case parentDashboard:
        return MaterialPageRoute(builder: (_) => const ParentDashboard());
      case studentDashboard:
        return MaterialPageRoute(builder: (_) => const StudentDashboard());
      case studentList:
        return MaterialPageRoute(builder: (_) => const StudentListScreen());
      case studentDetail:
        final args = settings.arguments as Map<String, dynamic>?;
        final studentId = args?['studentId'] as String? ?? '';
        return MaterialPageRoute(
          builder: (_) => StudentDetailScreen(studentId: studentId),
        );
      case payment:
        final args = settings.arguments as Map<String, dynamic>?;
        final studentId = args?['studentId'] as String? ?? '';
        return MaterialPageRoute(
          builder: (_) => PaymentScreen(studentId: studentId),
        );
      case receipt:
        final args = settings.arguments as Map<String, dynamic>?;
        final paymentId = args?['paymentId'] as String? ?? '';
        return MaterialPageRoute(
          builder: (_) => ReceiptScreen(paymentId: paymentId),
        );
      case attendance:
        final args = settings.arguments as Map<String, dynamic>?;
        final classId = args?['classId'] as String? ?? '';
        final date = args?['date'] as DateTime? ?? DateTime.now();
        return MaterialPageRoute(
          builder: (_) => AttendanceScreen(classId: classId, date: date),
        );
      case gradeEntry:
        final args = settings.arguments as Map<String, dynamic>?;
        final classId = args?['classId'] as String? ?? '';
        final subjectId = args?['subjectId'] as String? ?? '';
        return MaterialPageRoute(
          builder: (_) => GradeEntryScreen(
            classId: classId,
            subjectId: subjectId,
          ),
        );
      case reportCard:
        final args = settings.arguments as Map<String, dynamic>?;
        final studentId = args?['studentId'] as String? ?? '';
        final termId = args?['termId'] as String? ?? '';
        return MaterialPageRoute(
          builder: (_) => ReportCardScreen(
            studentId: studentId,
            termId: termId,
          ),
        );
      case announcement:
        final args = settings.arguments as Map<String, dynamic>?;
        final schoolId = args?['schoolId'] as String? ?? '';
        final classId = args?['classId'] as String? ?? '';
        return MaterialPageRoute(
          builder: (_) => AnnouncementScreen(
            schoolId: schoolId,
            classId: classId,
          ),
        );
      default:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
    }
  }
}
