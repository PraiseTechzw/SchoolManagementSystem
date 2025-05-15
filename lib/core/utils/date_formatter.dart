import 'package:intl/intl.dart';

/// Utility class for formatting dates
class DateFormatter {
  /// Format a date to a readable string (e.g., "Jan 1, 2023")
  static String format(DateTime date, {String format = 'MMM d, yyyy'}) {
    final formatter = DateFormat(format);
    return formatter.format(date);
  }
  
  /// Format a date to a full date string (e.g., "January 1, 2023")
  static String formatFull(DateTime date) {
    return format(date, format: 'MMMM d, yyyy');
  }
  
  /// Format a date to display with time (e.g., "Jan 1, 2023 14:30")
  static String formatWithTime(DateTime date) {
    return format(date, format: 'MMM d, yyyy HH:mm');
  }
  
  /// Format a date to short day name (e.g., "Mon")
  static String formatDayShort(DateTime date) {
    return format(date, format: 'E');
  }
  
  /// Format a date to full day name (e.g., "Monday")
  static String formatDayFull(DateTime date) {
    return format(date, format: 'EEEE');
  }
  
  /// Format a date to month and year (e.g., "January 2023")
  static String formatMonthYear(DateTime date) {
    return format(date, format: 'MMMM yyyy');
  }
  
  /// Format a time (e.g., "14:30")
  static String formatTime(DateTime date) {
    return format(date, format: 'HH:mm');
  }
  
  /// Format a time with seconds (e.g., "14:30:45")
  static String formatTimeWithSeconds(DateTime date) {
    return format(date, format: 'HH:mm:ss');
  }
  
  /// Format a date to ISO 8601 standard (for storage)
  static String formatISO(DateTime date) {
    return date.toIso8601String();
  }
  
  /// Parse a ISO 8601 string to DateTime
  static DateTime parseISO(String dateString) {
    return DateTime.parse(dateString);
  }
  
  /// Calculate age from date of birth
  static int calculateAge(DateTime birthDate) {
    final today = DateTime.now();
    int age = today.year - birthDate.year;
    
    // Handle if birthday hasn't occurred yet this year
    if (today.month < birthDate.month || 
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    
    return age;
  }
  
  /// Check if a date is today
  static bool isToday(DateTime date) {
    final today = DateTime.now();
    return date.year == today.year && 
           date.month == today.month && 
           date.day == today.day;
  }
  
  /// Check if a date is in the past
  static bool isPast(DateTime date) {
    final now = DateTime.now();
    return date.isBefore(now);
  }
  
  /// Calculate the difference in days between two dates
  static int daysBetween(DateTime from, DateTime to) {
    final fromDate = DateTime(from.year, from.month, from.day);
    final toDate = DateTime(to.year, to.month, to.day);
    return toDate.difference(fromDate).inDays;
  }
  
  /// Get a list of dates for a week containing the given date
  static List<DateTime> getDatesForWeek(DateTime date) {
    final List<DateTime> weekDates = [];
    final day = date.weekday;
    
    // Get the start of the week (Monday)
    final startOfWeek = date.subtract(Duration(days: day - 1));
    
    // Add all 7 days of the week
    for (int i = 0; i < 7; i++) {
      weekDates.add(startOfWeek.add(Duration(days: i)));
    }
    
    return weekDates;
  }
}
