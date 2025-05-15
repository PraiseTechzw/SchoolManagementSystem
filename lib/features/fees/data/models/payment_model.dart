import 'dart:convert';

import '../../../../core/enums/app_enums.dart';

/// Payment model representing a payment in the system
class PaymentModel {
  final String id;
  final String studentId;
  final String schoolId;
  final double amount;
  final DateTime paymentDate;
  final String paymentMethod;
  final String description;
  final String currency;
  final String? reference;
  final String? receiptNumber;
  final String termId;
  final String termName;
  final String academicYear;
  final String? notes;
  final bool isVerified;
  final String? verifiedBy;
  final DateTime? verifiedAt;
  final String recordedBy;
  final DateTime createdAt;
  final DateTime lastUpdated;
  final String? syncStatus;

  PaymentModel({
    required this.id,
    required this.studentId,
    required this.schoolId,
    required this.amount,
    required this.paymentDate,
    required this.paymentMethod,
    required this.description,
    required this.currency,
    this.reference,
    this.receiptNumber,
    required this.termId,
    required this.termName,
    required this.academicYear,
    this.notes,
    this.isVerified = false,
    this.verifiedBy,
    this.verifiedAt,
    required this.recordedBy,
    DateTime? createdAt,
    DateTime? lastUpdated,
    this.syncStatus,
  }) : 
    createdAt = createdAt ?? DateTime.now(),
    lastUpdated = lastUpdated ?? DateTime.now();

  /// Create a copy of this payment with the given fields replaced
  PaymentModel copyWith({
    String? id,
    String? studentId,
    String? schoolId,
    double? amount,
    DateTime? paymentDate,
    String? paymentMethod,
    String? description,
    String? currency,
    String? reference,
    String? receiptNumber,
    String? termId,
    String? termName,
    String? academicYear,
    String? notes,
    bool? isVerified,
    String? verifiedBy,
    DateTime? verifiedAt,
    String? recordedBy,
    DateTime? createdAt,
    DateTime? lastUpdated,
    String? syncStatus,
  }) {
    return PaymentModel(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      schoolId: schoolId ?? this.schoolId,
      amount: amount ?? this.amount,
      paymentDate: paymentDate ?? this.paymentDate,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      description: description ?? this.description,
      currency: currency ?? this.currency,
      reference: reference ?? this.reference,
      receiptNumber: receiptNumber ?? this.receiptNumber,
      termId: termId ?? this.termId,
      termName: termName ?? this.termName,
      academicYear: academicYear ?? this.academicYear,
      notes: notes ?? this.notes,
      isVerified: isVerified ?? this.isVerified,
      verifiedBy: verifiedBy ?? this.verifiedBy,
      verifiedAt: verifiedAt ?? this.verifiedAt,
      recordedBy: recordedBy ?? this.recordedBy,
      createdAt: createdAt ?? this.createdAt,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }

  /// Convert payment to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'studentId': studentId,
      'schoolId': schoolId,
      'amount': amount,
      'paymentDate': paymentDate.toIso8601String(),
      'paymentMethod': paymentMethod,
      'description': description,
      'currency': currency,
      'reference': reference,
      'receiptNumber': receiptNumber,
      'termId': termId,
      'termName': termName,
      'academicYear': academicYear,
      'notes': notes,
      'isVerified': isVerified,
      'verifiedBy': verifiedBy,
      'verifiedAt': verifiedAt?.toIso8601String(),
      'recordedBy': recordedBy,
      'createdAt': createdAt.toIso8601String(),
      'lastUpdated': lastUpdated.toIso8601String(),
      'syncStatus': syncStatus,
    };
  }

  /// Create a payment from a map
  factory PaymentModel.fromMap(Map<String, dynamic> map) {
    return PaymentModel(
      id: map['id'] ?? '',
      studentId: map['studentId'] ?? '',
      schoolId: map['schoolId'] ?? '',
      amount: map['amount']?.toDouble() ?? 0.0,
      paymentDate: map['paymentDate'] != null 
          ? DateTime.parse(map['paymentDate']) 
          : DateTime.now(),
      paymentMethod: map['paymentMethod'] ?? '',
      description: map['description'] ?? '',
      currency: map['currency'] ?? 'USD',
      reference: map['reference'],
      receiptNumber: map['receiptNumber'],
      termId: map['termId'] ?? '',
      termName: map['termName'] ?? '',
      academicYear: map['academicYear'] ?? '',
      notes: map['notes'],
      isVerified: map['isVerified'] ?? false,
      verifiedBy: map['verifiedBy'],
      verifiedAt: map['verifiedAt'] != null 
          ? DateTime.parse(map['verifiedAt']) 
          : null,
      recordedBy: map['recordedBy'] ?? '',
      createdAt: map['createdAt'] != null 
          ? DateTime.parse(map['createdAt']) 
          : DateTime.now(),
      lastUpdated: map['lastUpdated'] != null 
          ? DateTime.parse(map['lastUpdated']) 
          : DateTime.now(),
      syncStatus: map['syncStatus'],
    );
  }

  /// Convert payment to JSON
  String toJson() => json.encode(toMap());

  /// Create a payment from JSON
  factory PaymentModel.fromJson(String source) => PaymentModel.fromMap(json.decode(source));

  /// Get formatted amount with currency symbol
  String get formattedAmount {
    final currencySymbol = currency == 'USD' ? '\$' : 'ZWL\$';
    return '$currencySymbol ${amount.toStringAsFixed(2)}';
  }

  /// Check if payment was in USD
  bool get isUsd => currency == 'USD';

  /// Check if payment was in ZWL
  bool get isZwl => currency == 'ZWL';

  @override
  String toString() {
    return 'PaymentModel(id: $id, amount: $formattedAmount, date: $paymentDate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is PaymentModel &&
      other.id == id &&
      other.studentId == studentId &&
      other.schoolId == schoolId &&
      other.amount == amount &&
      other.paymentDate == paymentDate &&
      other.paymentMethod == paymentMethod &&
      other.currency == currency;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      studentId.hashCode ^
      schoolId.hashCode ^
      amount.hashCode ^
      paymentDate.hashCode ^
      paymentMethod.hashCode ^
      currency.hashCode;
  }
}
