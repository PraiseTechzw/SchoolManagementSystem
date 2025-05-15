/// Enum for user roles in the system
enum UserRole {
  admin,
  teacher,
  parent,
  student,
  clerk,
  principal,
}

/// Extension methods for UserRole enum
extension UserRoleExtension on UserRole {
  /// Convert string to UserRole
  static UserRole fromString(String value) {
    return UserRole.values.firstWhere(
      (role) => role.toString().split('.').last == value.toLowerCase(),
      orElse: () => UserRole.student,
    );
  }
  
  /// Get display name for the role
  String get displayName {
    switch (this) {
      case UserRole.admin:
        return 'Administrator';
      case UserRole.teacher:
        return 'Teacher';
      case UserRole.parent:
        return 'Parent';
      case UserRole.student:
        return 'Student';
      case UserRole.clerk:
        return 'Clerk';
      case UserRole.principal:
        return 'Principal';
    }
  }
}

/// Enum for payment methods
enum PaymentMethod {
  cash,
  bankTransfer,
  mobileMoney,
  check,
  card,
  other,
}

/// Enum for payment status
enum PaymentStatus {
  pending,
  completed,
  failed,
  refunded,
  partiallyPaid,
}

/// Enum for fee types
enum FeeType {
  tuition,
  boarding,
  uniform,
  books,
  transport,
  sports,
  examination,
  other,
}

/// Enum for currencies used
enum Currency {
  usd,
  zwl,
}

/// Extension for Currency enum
extension CurrencyExtension on Currency {
  /// Get currency symbol
  String get symbol {
    switch (this) {
      case Currency.usd:
        return '\$';
      case Currency.zwl:
        return 'ZWL\$';
    }
  }
}

/// Enum for attendance status
enum AttendanceStatus {
  present,
  absent,
  late,
  excused,
}

/// Enum for grade types (assessment types)
enum GradeType {
  test,
  exam,
  assignment,
  project,
  classwork,
  homework,
  quiz,
  practical,
  other,
}

/// Enum for term periods
enum TermPeriod {
  term1,
  term2,
  term3,
  yearEnd,
}

/// Enum for application themes
enum AppTheme {
  light,
  dark,
  system,
}

/// Enum for languages supported
enum AppLanguage {
  english,
  shona,
  ndebele,
}

/// Enum for sync status
enum SyncStatus {
  synced,
  pending,
  failed,
  conflicted,
}

/// Enum for notification types
enum NotificationType {
  fees,
  attendance,
  grades,
  announcement,
  event,
  exam,
  other,
}

/// Enum for schooling levels
enum SchoolLevel {
  preschool,
  primary,
  secondary,
  highSchool,
  college,
}

/// Enum for gender
enum Gender {
  male,
  female,
  other,
}