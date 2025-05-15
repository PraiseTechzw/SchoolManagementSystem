import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../../core/utils/validators.dart';
import '../../../shared/widgets/custom_app_bar.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../../shared/widgets/loading_indicator.dart';

/// Screen for recording a fee payment
class PaymentScreen extends ConsumerStatefulWidget {
  final String? studentId;
  final String? paymentId;
  
  const PaymentScreen({
    Key? key, 
    this.studentId,
    this.paymentId,
  }) : super(key: key);

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _referenceController = TextEditingController();
  final _notesController = TextEditingController();
  
  DateTime _dueDate = DateTime.now().add(const Duration(days: 30));
  DateTime _paymentDate = DateTime.now();
  String _feeType = 'Tuition';
  Currency _currency = Currency.usd;
  PaymentMethod _paymentMethod = PaymentMethod.cash;
  bool _isLoading = false;
  String? _errorMessage;
  
  // List of fee types for dropdown
  final List<String> _feeTypes = [
    'Tuition',
    'Boarding',
    'Uniform',
    'Sports',
    'Books',
    'Transport',
    'Exam',
    'Other'
  ];
  
  @override
  void initState() {
    super.initState();
    _loadPayment();
  }
  
  @override
  void dispose() {
    _amountController.dispose();
    _referenceController.dispose();
    _notesController.dispose();
    super.dispose();
  }
  
  /// Load existing payment if editing
  Future<void> _loadPayment() async {
    if (widget.paymentId != null) {
      // TODO: Implement loading payment data from repository
      setState(() {
        _isLoading = true;
      });
      
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Mock data
      setState(() {
        _amountController.text = '150.00';
        _feeType = 'Tuition';
        _currency = Currency.usd;
        _paymentMethod = PaymentMethod.cash;
        _referenceController.text = 'INV2023-045';
        _notesController.text = 'Term 2 fees';
        _dueDate = DateTime.now().add(const Duration(days: 30));
        _paymentDate = DateTime.now().subtract(const Duration(days: 2));
        _isLoading = false;
      });
    }
  }
  
  /// Save payment
  Future<void> _savePayment() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      // TODO: Implement saving payment to repository
      await Future.delayed(const Duration(seconds: 1));
      
      if (mounted) {
        Navigator.of(context).pushReplacementNamed(
          AppRoutes.receipt,
          arguments: {
            'paymentId': '123', // This would be the actual payment ID
          },
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error saving payment: $e';
        _isLoading = false;
      });
    }
  }

  /// Show date picker for due date
  Future<void> _selectDueDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
      });
    }
  }
  
  /// Show date picker for payment date
  Future<void> _selectPaymentDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _paymentDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    );
    
    if (picked != null && picked != _paymentDate) {
      setState(() {
        _paymentDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.paymentId != null ? 'Edit Payment' : 'Record Payment',
      ),
      body: LoadingContent(
        isLoading: _isLoading,
        loadingMessage: 'Loading payment data...',
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Fee amount
                CustomTextField(
                  labelText: 'Amount',
                  hintText: 'Enter amount',
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  prefixIcon: const Icon(Icons.attach_money),
                  validator: Validators.validateAmount,
                ),
                
                const SizedBox(height: 16),
                
                // Fee type dropdown
                Text(
                  'Fee Type',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _feeType,
                      isExpanded: true,
                      icon: const Icon(Icons.arrow_drop_down),
                      items: _feeTypes.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        if (value != null) {
                          setState(() {
                            _feeType = value;
                          });
                        }
                      },
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Currency and Payment Method in a row
                Row(
                  children: [
                    // Currency
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Currency',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<Currency>(
                                value: _currency,
                                isExpanded: true,
                                icon: const Icon(Icons.arrow_drop_down),
                                items: Currency.values.map((Currency value) {
                                  return DropdownMenuItem<Currency>(
                                    value: value,
                                    child: Text(value.toString().split('.').last.toUpperCase()),
                                  );
                                }).toList(),
                                onChanged: (Currency? value) {
                                  if (value != null) {
                                    setState(() {
                                      _currency = value;
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(width: 16),
                    
                    // Payment Method
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Payment Method',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<PaymentMethod>(
                                value: _paymentMethod,
                                isExpanded: true,
                                icon: const Icon(Icons.arrow_drop_down),
                                items: PaymentMethod.values.map((PaymentMethod value) {
                                  return DropdownMenuItem<PaymentMethod>(
                                    value: value,
                                    child: Text(_formatPaymentMethod(value)),
                                  );
                                }).toList(),
                                onChanged: (PaymentMethod? value) {
                                  if (value != null) {
                                    setState(() {
                                      _paymentMethod = value;
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Due date and Payment date in a row
                Row(
                  children: [
                    // Due Date
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Due Date',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          InkWell(
                            onTap: _selectDueDate,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 12.0,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.calendar_today, size: 18),
                                  const SizedBox(width: 8),
                                  Text(
                                    DateFormat('dd/MM/yyyy').format(_dueDate),
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(width: 16),
                    
                    // Payment Date
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Payment Date',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          InkWell(
                            onTap: _selectPaymentDate,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 12.0,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.calendar_today, size: 18),
                                  const SizedBox(width: 8),
                                  Text(
                                    DateFormat('dd/MM/yyyy').format(_paymentDate),
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Reference Number
                CustomTextField(
                  labelText: 'Reference/Receipt Number (Optional)',
                  hintText: 'Enter reference number',
                  controller: _referenceController,
                  prefixIcon: const Icon(Icons.receipt_long),
                ),
                
                const SizedBox(height: 16),
                
                // Notes
                TextField(
                  controller: _notesController,
                  decoration: InputDecoration(
                    labelText: 'Notes (Optional)',
                    hintText: 'Add any additional notes',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    prefixIcon: const Icon(Icons.note),
                  ),
                  maxLines: 3,
                ),
                
                const SizedBox(height: 24),
                
                // Error message
                if (_errorMessage != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red),
                    ),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                
                // Save button
                CustomButton(
                  text: 'Save Payment',
                  onPressed: _savePayment,
                  isLoading: _isLoading,
                  isFullWidth: true,
                  icon: Icons.save,
                ),
                
                const SizedBox(height: 16),
                
                // Cancel button
                OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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