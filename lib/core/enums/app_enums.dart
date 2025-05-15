/// User roles available in the system
enum UserRole {
  admin,
  clerk,
  teacher,
  parent,
  student;
  
  @override
  String toString() {
    return name;
  }
  
  /// Convert string to UserRole enum
  static UserRole fromString(String value) {
    return UserRole.values.firstWhere(
      (role) => role.toString() == value.toLowerCase(),
      orElse: () => UserRole.student,
    );
  }
}

/// Supported languages in the app
enum AppLanguage {
  english('en', 'English'),
  shona('sn', 'Shona'),
  ndebele('nd', 'Ndebele');
  
  final String code;
  final String displayName;
  
  const AppLanguage(this.code, this.displayName);
  
  @override
  String toString() {
    return displayName;
  }
  
  /// Convert code to AppLanguage enum
  static AppLanguage fromCode(String code) {
    return AppLanguage.values.firstWhere(
      (language) => language.code == code,
      orElse: () => AppLanguage.english,
    );
  }
}

/// Gender options
enum Gender {
  male('Male'),
  female('Female'),
  other('Other');
  
  final String displayName;
  
  const Gender(this.displayName);
  
  @override
  String toString() {
    return displayName;
  }
  
  /// Convert display name to Gender enum
  static Gender fromString(String value) {
    return Gender.values.firstWhere(
      (gender) => gender.displayName.toLowerCase() == value.toLowerCase(),
      orElse: () => Gender.other,
    );
  }
}

/// Currency types supported
enum Currency {
  usd('USD', '\$'),
  zwl('ZWL', 'ZWL\$');
  
  final String code;
  final String symbol;
  
  const Currency(this.code, this.symbol);
  
  @override
  String toString() {
    return code;
  }
  
  /// Convert code to Currency enum
  static Currency fromCode(String code) {
    return Currency.values.firstWhere(
      (currency) => currency.code == code,
      orElse: () => Currency.usd,
    );
  }
}

/// Payment methods
enum PaymentMethod {
  cash('Cash'),
  bankTransfer('Bank Transfer'),
  mobileMoney('Mobile Money');
  
  final String displayName;
  
  const PaymentMethod(this.displayName);
  
  @override
  String toString() {
    return displayName;
  }
  
  /// Convert display name to PaymentMethod enum
  static PaymentMethod fromString(String value) {
    return PaymentMethod.values.firstWhere(
      (method) => method.displayName.toLowerCase() == value.toLowerCase(),
      orElse: () => PaymentMethod.cash,
    );
  }
}

/// Attendance status
enum AttendanceStatus {
  present('Present'),
  absent('Absent'),
  late('Late'),
  excused('Excused');
  
  final String displayName;
  
  const AttendanceStatus(this.displayName);
  
  @override
  String toString() {
    return displayName;
  }
  
  /// Convert display name to AttendanceStatus enum
  static AttendanceStatus fromString(String value) {
    return AttendanceStatus.values.firstWhere(
      (status) => status.displayName.toLowerCase() == value.toLowerCase(),
      orElse: () => AttendanceStatus.absent,
    );
  }
}

/// Sync status for offline-first operations
enum SyncStatus {
  completed('Completed'),
  pending('Pending'),
  error('Error');
  
  final String displayName;
  
  const SyncStatus(this.displayName);
  
  @override
  String toString() {
    return displayName;
  }
  
  /// Convert display name to SyncStatus enum
  static SyncStatus fromString(String value) {
    return SyncStatus.values.firstWhere(
      (status) => status.displayName.toLowerCase() == value.toLowerCase(),
      orElse: () => SyncStatus.pending,
    );
  }
}

/// Term periods
enum Term {
  first('First Term'),
  second('Second Term'),
  third('Third Term');
  
  final String displayName;
  
  const Term(this.displayName);
  
  @override
  String toString() {
    return displayName;
  }
  
  /// Convert display name to Term enum
  static Term fromString(String value) {
    return Term.values.firstWhere(
      (term) => term.displayName.toLowerCase() == value.toLowerCase(),
      orElse: () => Term.first,
    );
  }
}

/// Grade types
enum GradeType {
  quiz('Quiz'),
  assignment('Assignment'),
  midterm('Midterm'),
  final_('Final');
  
  final String displayName;
  
  const GradeType(this.displayName);
  
  @override
  String toString() {
    return displayName;
  }
  
  /// Convert display name to GradeType enum
  static GradeType fromString(String value) {
    return GradeType.values.firstWhere(
      (type) => type.displayName.toLowerCase() == value.toLowerCase(),
      orElse: () => GradeType.assignment,
    );
  }
}

/// Announcement audience types
enum AnnouncementAudience {
  school('School-wide'),
  class_('Class'),
  parents('Parents'),
  teachers('Teachers');
  
  final String displayName;
  
  const AnnouncementAudience(this.displayName);
  
  @override
  String toString() {
    return displayName;
  }
  
  /// Convert display name to AnnouncementAudience enum
  static AnnouncementAudience fromString(String value) {
    return AnnouncementAudience.values.firstWhere(
      (audience) => audience.displayName.toLowerCase() == value.toLowerCase(),
      orElse: () => AnnouncementAudience.school,
    );
  }
}
