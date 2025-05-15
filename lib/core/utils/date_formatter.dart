import 'package:intl/intl.dart';

/// Utility class for formatting dates
class DateFormatter {
  /// Format date as 'dd MMM yyyy' (e.g., 15 Jan 2023)
  static String formatShortDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }
  
  /// Format date as 'EEEE, MMMM d, yyyy' (e.g., Monday, January 15, 2023)
  static String formatLongDate(DateTime date) {
    return DateFormat('EEEE, MMMM d, yyyy').format(date);
  }
  
  /// Format date as 'MMM d, yyyy' (e.g., Jan 15, 2023)
  static String formatMediumDate(DateTime date) {
    return DateFormat('MMM d, yyyy').format(date);
  }
  
  /// Format date as 'dd/MM/yyyy' (e.g., 15/01/2023)
  static String formatSlashDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }
  
  /// Format date as 'yyyy-MM-dd' (e.g., 2023-01-15)
  static String formatIsoDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }
  
  /// Format date and time as 'dd MMM yyyy, HH:mm' (e.g., 15 Jan 2023, 14:30)
  static String formatDateTime(DateTime date) {
    return DateFormat('dd MMM yyyy, HH:mm').format(date);
  }
  
  /// Format time as 'HH:mm' (e.g., 14:30)
  static String formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }
  
  /// Get age from date of birth
  static int getAge(DateTime birthDate) {
    final today = DateTime.now();
    int age = today.year - birthDate.year;
    
    // Adjust age if birthday hasn't occurred yet this year
    if (today.month < birthDate.month || 
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    
    return age;
  }
  
  /// Format relative time (e.g., 2 hours ago, Yesterday, etc.)
  static String getRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inDays < 2) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    }
  }
  
  /// Get the start of the day (00:00:00)
  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
  
  /// Get the end of the day (23:59:59)
  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59);
  }
  
  /// Get the start of the month
  static DateTime startOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }
  
  /// Get the end of the month
  static DateTime endOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0, 23, 59, 59);
  }
  
  /// Get the start of the year
  static DateTime startOfYear(DateTime date) {
    return DateTime(date.year, 1, 1);
  }
  
  /// Get the end of the year
  static DateTime endOfYear(DateTime date) {
    return DateTime(date.year, 12, 31, 23, 59, 59);
  }
  
  /// Get the academic year string (e.g., 2023-2024)
  static String getAcademicYear(DateTime date) {
    // Academic year typically starts in January in Zimbabwe
    final year = date.year;
    return '$year-${year + 1}';
  }
}