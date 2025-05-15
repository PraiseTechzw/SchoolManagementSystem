import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../config/routes.dart';
import '../config/themes.dart';
import '../core/providers/app_providers.dart';
import '../core/providers/auth_provider.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/dashboard/presentation/screens/admin_dashboard.dart';
import '../features/dashboard/presentation/screens/clerk_dashboard.dart';
import '../features/dashboard/presentation/screens/teacher_dashboard.dart';
import '../features/dashboard/presentation/screens/parent_dashboard.dart';
import '../features/dashboard/presentation/screens/student_dashboard.dart';

class ChikoroPro extends ConsumerWidget {
  const ChikoroPro({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);
    
    return MaterialApp(
      title: 'ChikoroPro',
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: themeMode,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      initialRoute: AppRoutes.initial,
      onGenerateRoute: AppRoutes.onGenerateRoute,
      home: const AppHome(),
    );
  }
}

class AppHome extends ConsumerWidget {
  const AppHome({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    
    return authState.when(
      data: (user) {
        if (user == null) {
          return const LoginScreen();
        }
        
        final userRole = ref.watch(userRoleProvider);
        return userRole.when(
          data: (role) {
            switch (role) {
              case 'admin':
                return const AdminDashboard();
              case 'clerk':
                return const ClerkDashboard();
              case 'teacher':
                return const TeacherDashboard();
              case 'parent':
                return const ParentDashboard();
              case 'student':
                return const StudentDashboard();
              default:
                return const LoginScreen();
            }
          },
          loading: () => const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ),
          error: (_, __) => const LoginScreen(),
        );
      },
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (_, __) => const LoginScreen(),
    );
  }
}
