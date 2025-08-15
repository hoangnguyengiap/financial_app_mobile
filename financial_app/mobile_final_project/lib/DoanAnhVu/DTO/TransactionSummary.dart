import 'package:intl/intl.dart';

class TransactionSummary {
  final double amount;
  final DateTime transactionDate;
  final String categoryName;
  final String categoryType;

  TransactionSummary({
    required this.amount,
    required this.transactionDate,
    required this.categoryName,
    required this.categoryType,
  });

  // Factory method to parse from JSON
  factory TransactionSummary.fromJson(Map<String, dynamic> json) {
    return TransactionSummary(
      amount: (json['amount'] as num).toDouble(),
      transactionDate: DateTime.parse(json['transactionDate']),
      categoryName: json['categoryName'],
      categoryType: json['categoryType'],
    );
  }
}