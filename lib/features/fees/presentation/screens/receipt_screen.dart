import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../config/app_config.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../shared/widgets/custom_app_bar.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/loading_indicator.dart';

/// Screen for viewing and sharing a payment receipt
class ReceiptScreen extends ConsumerStatefulWidget {
  final String paymentId;
  
  const ReceiptScreen({
    Key? key,
    required this.paymentId,
  }) : super(key: key);

  @override
  ConsumerState<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends ConsumerState<ReceiptScreen> {
  bool _isLoading = true;
  String? _errorMessage;
  
  // Receipt data
  late String _receiptNumber;
  late String _studentName;
  late String _className;
  late String _feeType;
  late double _amount;
  late Currency _currency;
  late PaymentMethod _paymentMethod;
  late DateTime _paymentDate;
  late String _receivedBy;
  late String _notes;
  
  @override
  void initState() {
    super.initState();
    _loadReceiptData();
  }
  
  /// Load receipt data
  Future<void> _loadReceiptData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      // TODO: Load actual data from repository
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock data
      setState(() {
        _receiptNumber = 'RCP-${widget.paymentId}';
        _studentName = 'John Doe';
        _className = 'Grade 9A';
        _feeType = 'Tuition';
        _amount = 150.00;
        _currency = Currency.usd;
        _paymentMethod = PaymentMethod.cash;
        _paymentDate = DateTime.now();
        _receivedBy = 'Jane Smith';
        _notes = 'Term 2 fees';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading receipt data: $e';
        _isLoading = false;
      });
    }
  }
  
  /// Share receipt
  Future<void> _shareReceipt() async {
    // TODO: Implement sharing functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sharing functionality will be implemented soon.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
  
  /// Print receipt
  Future<void> _printReceipt() async {
    // TODO: Implement printing functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Printing functionality will be implemented soon.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
  
  /// Record another payment
  void _recordAnotherPayment() {
    Navigator.of(context).pushReplacementNamed(AppRoutes.addEditFee);
  }
  
  /// Navigate back to payments list
  void _backToPayments() {
    Navigator.of(context).pushReplacementNamed(AppRoutes.feesList);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Payment Receipt',
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareReceipt,
            tooltip: 'Share Receipt',
          ),
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: _printReceipt,
            tooltip: 'Print Receipt',
          ),
        ],
      ),
      body: LoadingContent(
        isLoading: _isLoading,
        loadingMessage: 'Loading receipt...',
        child: _errorMessage != null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    CustomButton(
                      text: 'Try Again',
                      onPressed: _loadReceiptData,
                      icon: Icons.refresh,
                    ),
                  ],
                ),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Receipt card
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // School name and receipt header
                            Center(
                              child: Column(
                                children: [
                                  Text(
                                    AppConfig.appName,
                                    style: theme.textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: theme.primaryColor,
                                    ),
                                  ),
                                  const Text(
                                    'PAYMENT RECEIPT',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: theme.primaryColor,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      'Receipt #: $_receiptNumber',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            const SizedBox(height: 24),
                            
                            // Date and Student info
                            Row(
                              children: [
                                Expanded(
                                  child: _buildInfoRow(
                                    'Date:',
                                    DateFormat('dd/MM/yyyy').format(_paymentDate),
                                  ),
                                ),
                                Expanded(
                                  child: _buildInfoRow(
                                    'Time:',
                                    DateFormat('HH:mm').format(_paymentDate),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            _buildInfoRow('Student:', _studentName),
                            const SizedBox(height: 8),
                            _buildInfoRow('Class:', _className),
                            
                            const Divider(height: 32),
                            
                            // Payment info
                            _buildInfoRow('Fee Type:', _feeType),
                            const SizedBox(height: 8),
                            _buildInfoRow(
                              'Amount:',
                              '${_getCurrencySymbol(_currency)}${_amount.toStringAsFixed(2)}',
                              isBold: true,
                            ),
                            const SizedBox(height: 8),
                            _buildInfoRow(
                              'Payment Method:',
                              _formatPaymentMethod(_paymentMethod),
                            ),
                            
                            if (_notes.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              _buildInfoRow('Notes:', _notes),
                            ],
                            
                            const Divider(height: 32),
                            
                            // Footer info
                            _buildInfoRow('Received By:', _receivedBy),
                            const SizedBox(height: 24),
                            
                            // Signature line
                            Center(
                              child: Column(
                                children: [
                                  Container(
                                    width: 200,
                                    height: 1,
                                    color: Colors.black,
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Authorized Signature',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            
                            const SizedBox(height: 24),
                            
                            // Thank you message
                            const Center(
                              child: Text(
                                'Thank you for your payment!',
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _backToPayments,
                            icon: const Icon(Icons.list),
                            label: const Text('Back to Payments'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: CustomButton(
                            text: 'New Payment',
                            onPressed: _recordAnotherPayment,
                            icon: Icons.add,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }
  
  /// Build an information row with label and value
  Widget _buildInfoRow(String label, String value, {bool isBold = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }
  
  /// Get currency symbol
  String _getCurrencySymbol(Currency currency) {
    switch (currency) {
      case Currency.usd:
        return '\$';
      case Currency.zwl:
        return 'ZWL';
    }
  }
  
  /// Format payment method for display
  String _formatPaymentMethod(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.cash:
        return 'Cash';
      case PaymentMethod.bankTransfer:
        return 'Bank Transfer';
      case PaymentMethod.mobileMoney:
        return 'Mobile Money';
      case PaymentMethod.check:
        return 'Check';
      case PaymentMethod.card:
        return 'Card';
      case PaymentMethod.other:
        return 'Other';
    }
  }
}