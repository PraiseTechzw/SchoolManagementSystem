import 'package:intl/intl.dart';

import '../enums/app_enums.dart';

/// Utility class for formatting currency values
class CurrencyFormatter {
  /// Format a currency value
  static String format({
    required double amount,
    required Currency currency,
    int? decimalPlaces,
  }) {
    final formatter = NumberFormat.currency(
      symbol: currency.symbol,
      decimalDigits: decimalPlaces ?? 2,
    );
    
    return formatter.format(amount);
  }
  
  /// Format USD amount
  static String formatUSD(double amount, {int? decimalPlaces}) {
    return format(
      amount: amount,
      currency: Currency.usd,
      decimalPlaces: decimalPlaces,
    );
  }
  
  /// Format ZWL amount
  static String formatZWL(double amount, {int? decimalPlaces}) {
    return format(
      amount: amount,
      currency: Currency.zwl,
      decimalPlaces: decimalPlaces,
    );
  }
  
  /// Parse currency string to double
  static double parse(String value) {
    // Remove any currency symbols or spaces
    final cleanedValue = value
        .replaceAll(Currency.usd.symbol, '')
        .replaceAll(Currency.zwl.symbol, '')
        .replaceAll(',', '')
        .replaceAll(' ', '')
        .trim();
    
    return double.tryParse(cleanedValue) ?? 0.0;
  }
  
  /// Convert USD to ZWL based on exchange rate
  static double usdToZwl(double usdAmount, double exchangeRate) {
    return usdAmount * exchangeRate;
  }
  
  /// Convert ZWL to USD based on exchange rate
  static double zwlToUsd(double zwlAmount, double exchangeRate) {
    if (exchangeRate <= 0) return 0.0;
    return zwlAmount / exchangeRate;
  }
}
