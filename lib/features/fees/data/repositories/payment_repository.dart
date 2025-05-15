import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

import '../../../../config/app_config.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../../core/services/firebase_service.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../../../core/utils/sync_utils.dart';
import '../models/payment_model.dart';

final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  return PaymentRepository();
});

/// Repository for handling payment data operations
class PaymentRepository {
  /// Get all payments
  Future<List<PaymentModel>> getAllPayments({
    String? schoolId,
    String? studentId,
    String? termId,
    String? currency,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      // Query local storage first
      final box = LocalStorageService.paymentBox;
      final paymentsData = LocalStorageService.getAllItems(box);
      
      // Filter data based on parameters
      final filteredData = paymentsData.where((data) {
        // Skip deleted items
        if (data['isDeleted'] == true) return false;
        
        // Filter by school
        if (schoolId != null && data['schoolId'] != schoolId) return false;
        
        // Filter by student
        if (studentId != null && data['studentId'] != studentId) return false;
        
        // Filter by term
        if (termId != null && data['termId'] != termId) return false;
        
        // Filter by currency
        if (currency != null && data['currency'] != currency) return false;
        
        // Filter by date range
        if (startDate != null || endDate != null) {
          final paymentDate = DateTime.parse(data['paymentDate']);
          
          if (startDate != null && paymentDate.isBefore(startDate)) return false;
          if (endDate != null && paymentDate.isAfter(endDate)) return false;
        }
        
        return true;
      }).toList();
      
      // Convert to models
      final payments = filteredData.map((data) => PaymentModel.fromMap(data)).toList();
      
      // Sort by payment date, newest first
      payments.sort((a, b) => b.paymentDate.compareTo(a.paymentDate));
      
      return payments;
    } catch (e) {
      debugPrint('Error getting all payments: $e');
      return [];
    }
  }

  /// Get payment by ID
  Future<PaymentModel?> getPaymentById(String id) async {
    try {
      // Try to get from local storage first
      final box = LocalStorageService.paymentBox;
      final paymentData = LocalStorageService.getItemById(box, id);
      
      if (paymentData != null && paymentData['isDeleted'] != true) {
        return PaymentModel.fromMap(paymentData);
      }
      
      // If not in local storage, try to get from Firestore
      // Only do this if there's an internet connection
      final isConnected = await SyncUtils.checkConnectivity();
      if (isConnected) {
        final doc = await FirebaseService.getDocument(
          collection: AppConfig.paymentsCollection,
          documentId: id,
        );
        
        if (doc.exists && doc.data() != null) {
          final paymentData = doc.data()!;
          
          // Add ID to the data if it's not there
          if (!paymentData.containsKey('id')) {
            paymentData['id'] = id;
          }
          
          // Save to local storage
          await LocalStorageService.saveItem(box, id, paymentData);
          
          // Update sync status to completed
          await LocalStorageService.updateSyncStatus(
            box,
            id,
            SyncStatus.completed,
          );
          
          return PaymentModel.fromMap(paymentData);
        }
      }
      
      return null;
    } catch (e) {
      debugPrint('Error getting payment by ID: $e');
      return null;
    }
  }

  /// Create a new payment
  Future<PaymentModel?> createPayment(PaymentModel payment) async {
    try {
      // Generate ID if not provided
      final id = payment.id.isEmpty 
          ? LocalStorageService.generateId() 
          : payment.id;
      
      // Generate receipt number if not provided
      final receiptNumber = payment.receiptNumber ?? 'R${DateTime.now().millisecondsSinceEpoch}';
      
      // Update payment model with generated ID and receipt number
      final newPayment = payment.copyWith(
        id: id,
        receiptNumber: receiptNumber,
        createdAt: DateTime.now(),
        lastUpdated: DateTime.now(),
      );
      
      // Save to local storage
      await LocalStorageService.saveItem(
        LocalStorageService.paymentBox,
        id,
        newPayment.toMap(),
      );
      
      return newPayment;
    } catch (e) {
      debugPrint('Error creating payment: $e');
      return null;
    }
  }

  /// Update a payment
  Future<PaymentModel?> updatePayment(PaymentModel payment) async {
    try {
      // Update the last updated timestamp
      final updatedPayment = payment.copyWith(
        lastUpdated: DateTime.now(),
      );
      
      // Save to local storage
      await LocalStorageService.saveItem(
        LocalStorageService.paymentBox,
        payment.id,
        updatedPayment.toMap(),
      );
      
      return updatedPayment;
    } catch (e) {
      debugPrint('Error updating payment: $e');
      return null;
    }
  }

  /// Delete a payment
  Future<bool> deletePayment(String id) async {
    try {
      // Mark as deleted in local storage
      await LocalStorageService.deleteItem(
        LocalStorageService.paymentBox,
        id,
      );
      
      return true;
    } catch (e) {
      debugPrint('Error deleting payment: $e');
      return false;
    }
  }

  /// Verify a payment
  Future<PaymentModel?> verifyPayment(String id, String verifierUserId) async {
    try {
      // Get the payment
      final payment = await getPaymentById(id);
      if (payment == null) {
        throw Exception('Payment not found');
      }
      
      // Update the payment as verified
      final verifiedPayment = payment.copyWith(
        isVerified: true,
        verifiedBy: verifierUserId,
        verifiedAt: DateTime.now(),
        lastUpdated: DateTime.now(),
      );
      
      // Save to local storage
      await LocalStorageService.saveItem(
        LocalStorageService.paymentBox,
        id,
        verifiedPayment.toMap(),
      );
      
      return verifiedPayment;
    } catch (e) {
      debugPrint('Error verifying payment: $e');
      return null;
    }
  }
  
  /// Get total payments for a student
  Future<Map<String, double>> getTotalPaymentsForStudent(
    String studentId, {
    String? termId,
    String? academicYear,
  }) async {
    try {
      // Get all payments for the student
      final payments = await getAllPayments(
        studentId: studentId,
        termId: termId,
      );
      
      // Calculate totals by currency
      double usdTotal = 0.0;
      double zwlTotal = 0.0;
      
      for (final payment in payments) {
        if (payment.currency == 'USD') {
          usdTotal += payment.amount;
        } else if (payment.currency == 'ZWL') {
          zwlTotal += payment.amount;
        }
      }
      
      return {
        'USD': usdTotal,
        'ZWL': zwlTotal,
      };
    } catch (e) {
      debugPrint('Error getting total payments for student: $e');
      return {
        'USD': 0.0,
        'ZWL': 0.0,
      };
    }
  }
  
  /// Get payment statistics for a school
  Future<Map<String, dynamic>> getPaymentStatistics(
    String schoolId, {
    String? termId,
    String? academicYear,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      // Get all payments for the school within the specified constraints
      final payments = await getAllPayments(
        schoolId: schoolId,
        termId: termId,
        startDate: startDate,
        endDate: endDate,
      );
      
      if (payments.isEmpty) {
        return {
          'totalUsd': 0.0,
          'totalZwl': 0.0,
          'paymentCount': 0,
          'averagePaymentUsd': 0.0,
          'paymentsByMethod': {},
          'dailyPayments': {},
        };
      }
      
      // Calculate statistics
      double totalUsd = 0.0;
      double totalZwl = 0.0;
      final paymentsByMethod = <String, int>{};
      final dailyPayments = <String, double>{};
      
      for (final payment in payments) {
        // Track totals by currency
        if (payment.currency == 'USD') {
          totalUsd += payment.amount;
        } else if (payment.currency == 'ZWL') {
          totalZwl += payment.amount;
        }
        
        // Track counts by payment method
        final method = payment.paymentMethod;
        paymentsByMethod[method] = (paymentsByMethod[method] ?? 0) + 1;
        
        // Track daily payments (in USD equivalent)
        final dateKey = payment.paymentDate.toString().split(' ')[0]; // YYYY-MM-DD
        final amountInUsd = payment.currency == 'USD' 
            ? payment.amount 
            : payment.amount / 3500; // Use a simple conversion rate for ZWL
        
        dailyPayments[dateKey] = (dailyPayments[dateKey] ?? 0.0) + amountInUsd;
      }
      
      // Calculate averages
      final averagePaymentUsd = payments.isNotEmpty 
          ? totalUsd / payments.where((p) => p.currency == 'USD').length 
          : 0.0;
      
      return {
        'totalUsd': totalUsd,
        'totalZwl': totalZwl,
        'paymentCount': payments.length,
        'averagePaymentUsd': averagePaymentUsd,
        'paymentsByMethod': paymentsByMethod,
        'dailyPayments': dailyPayments,
      };
    } catch (e) {
      debugPrint('Error getting payment statistics: $e');
      return {
        'totalUsd': 0.0,
        'totalZwl': 0.0,
        'paymentCount': 0,
        'averagePaymentUsd': 0.0,
        'paymentsByMethod': {},
        'dailyPayments': {},
      };
    }
  }
  
  /// Sync payments with server
  Future<void> syncPayments() async {
    try {
      await SyncUtils.fullSync();
    } catch (e) {
      debugPrint('Error syncing payments: $e');
    }
  }
}
