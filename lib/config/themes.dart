import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'constants.dart';

class AppThemes {
  // Admin theme color
  static const Color adminPrimaryColor = Color(0xFF1A237E);
  static const Color adminSecondaryColor = Color(0xFF3949AB);
  
  // Clerk theme color
  static const Color clerkPrimaryColor = Color(0xFF00695C);
  static const Color clerkSecondaryColor = Color(0xFF00897B);
  
  // Teacher theme color
  static const Color teacherPrimaryColor = Color(0xFF4527A0);
  static const Color teacherSecondaryColor = Color(0xFF673AB7);
  
  // Parent theme color
  static const Color parentPrimaryColor = Color(0xFF0D47A1);
  static const Color parentSecondaryColor = Color(0xFF1976D2);
  
  // Student theme color
  static const Color studentPrimaryColor = Color(0xFF1B5E20);
  static const Color studentSecondaryColor = Color(0xFF388E3C);
  
  // Error color
  static const Color errorColor = Color(0xFFD32F2F);

  // Warning color
  static const Color warningColor = Color(0xFFFF9800);
  
  // Success color
  static const Color successColor = Color(0xFF43A047);
  
  // Info color
  static const Color infoColor = Color(0xFF2196F3);
  
  // Generic light theme
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: AppColors.primaryColor,
    colorScheme: ColorScheme.light(
      primary: AppColors.primaryColor,
      secondary: AppColors.secondaryColor,
      error: errorColor,
    ),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primaryColor,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.nunito(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    textTheme: GoogleFonts.nunitoTextTheme(),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      filled: true,
      fillColor: Colors.grey[100],
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    dividerTheme: const DividerThemeData(
      thickness: 1,
      space: 16,
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );

  // Generic dark theme
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: AppColors.primaryColorDark,
    colorScheme: ColorScheme.dark(
      primary: AppColors.primaryColorDark,
      secondary: AppColors.secondaryColorDark,
      error: errorColor,
    ),
    scaffoldBackgroundColor: const Color(0xFF121212),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primaryColorDark,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.nunito(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    textTheme: GoogleFonts.nunitoTextTheme(ThemeData.dark().textTheme),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      filled: true,
      fillColor: Colors.grey[800],
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    dividerTheme: const DividerThemeData(
      thickness: 1,
      space: 16,
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
  
  // Get role-specific theme
  static ThemeData getRoleTheme(String role, {bool isDark = false}) {
    final baseTheme = isDark ? darkTheme : lightTheme;
    
    switch (role) {
      case 'admin':
        return baseTheme.copyWith(
          primaryColor: adminPrimaryColor,
          colorScheme: baseTheme.colorScheme.copyWith(
            primary: adminPrimaryColor,
            secondary: adminSecondaryColor,
          ),
          appBarTheme: baseTheme.appBarTheme.copyWith(
            backgroundColor: adminPrimaryColor,
          ),
        );
      case 'clerk':
        return baseTheme.copyWith(
          primaryColor: clerkPrimaryColor,
          colorScheme: baseTheme.colorScheme.copyWith(
            primary: clerkPrimaryColor,
            secondary: clerkSecondaryColor,
          ),
          appBarTheme: baseTheme.appBarTheme.copyWith(
            backgroundColor: clerkPrimaryColor,
          ),
        );
      case 'teacher':
        return baseTheme.copyWith(
          primaryColor: teacherPrimaryColor,
          colorScheme: baseTheme.colorScheme.copyWith(
            primary: teacherPrimaryColor,
            secondary: teacherSecondaryColor,
          ),
          appBarTheme: baseTheme.appBarTheme.copyWith(
            backgroundColor: teacherPrimaryColor,
          ),
        );
      case 'parent':
        return baseTheme.copyWith(
          primaryColor: parentPrimaryColor,
          colorScheme: baseTheme.colorScheme.copyWith(
            primary: parentPrimaryColor,
            secondary: parentSecondaryColor,
          ),
          appBarTheme: baseTheme.appBarTheme.copyWith(
            backgroundColor: parentPrimaryColor,
          ),
        );
      case 'student':
        return baseTheme.copyWith(
          primaryColor: studentPrimaryColor,
          colorScheme: baseTheme.colorScheme.copyWith(
            primary: studentPrimaryColor,
            secondary: studentSecondaryColor,
          ),
          appBarTheme: baseTheme.appBarTheme.copyWith(
            backgroundColor: studentPrimaryColor,
          ),
        );
      default:
        return baseTheme;
    }
  }
}
