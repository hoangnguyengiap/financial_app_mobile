// lib/models/transaction_history.dart
import 'package:final_project/DataConverter.dart';
import 'package:flutter/widgets.dart'; 
import 'package:intl/intl.dart';

class TransactionHistory {
  final int transactionID;
  final double amount;
  final DateTime transactionDate;
  final String categoryName;
  final String colorCode;
  final int iconCode;
  final String categoryType;
  final bool isIncome; // Thêm thuộc tính này


  TransactionHistory({
    required this.transactionID,
    required this.amount,
    required this.transactionDate,
    required this.categoryName,
    required this.colorCode,
    required this.iconCode,
    required this.categoryType,
    required this.isIncome,
  });

  factory TransactionHistory.fromJson(Map<String, dynamic> json) {
    // Chuyển đổi CategoryType sang isIncome
    final isIncome = json['categoryType'] == 'Income';

    return TransactionHistory(
      transactionID: json['transactionID'],
      amount: (json['amount'] as num).toDouble(),
      transactionDate: DateTime.parse(json['transactionDate']),
      categoryName: json['categoryName'],
      colorCode: json['colorCode'],
      iconCode: json['iconCode'],
      categoryType: json['categoryType'],
      isIncome: isIncome,
    );
  }
}

// Giả sử DataConverter của bạn có hàm để chuyển đổi màu hex nếu cần
// Nếu không, bạn có thể bỏ qua hoặc điều chỉnh
class DataConverter {
  Color hexToColor(String hexCode) {
    String formattedHex = hexCode.replaceAll("#", "");
    return Color(int.parse("0xFF$formattedHex"));
  }
}