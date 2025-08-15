// class Transaction {
//   final String id;
//   final String type;
//   final String category;
//   final double amount;
//   final DateTime date;
//   final int icon;
//   final String iconColor;
//   final bool isIncome;

//   Transaction({
//     required this.id,
//     required this.type,
//     required this.category,
//     required this.amount,
//     required this.date,
//     required this.icon,
//     required this.iconColor,
//     required this.isIncome,
//   });
  
// }
// lib/DoanAnhVu/model/transaction.dart (Cập nhật)

// Import các thư viện cần thiết nếu chưa có
import 'package:flutter/material.dart'; // Để dùng Icons

class Transaction {
  // Các trường sẽ được gửi lên Backend
  final double amount;
  final DateTime date; // `transactionDate` trong backend
  final String note; // `note` trong backend
  final bool isIncome;
  final int userId; // ID của người dùng thực hiện giao dịch
  final int categoryId; // ID của danh mục

  // Các trường bổ sung dành cho hiển thị ở Frontend (tùy chọn, không gửi lên backend)
  // Nếu bạn muốn hiển thị tên danh mục, biểu tượng, màu sắc trên frontend
  // và các giá trị này không được gửi trực tiếp lên backend thông qua model Transaction
  // bạn có thể thêm chúng vào đây hoặc xử lý riêng.
  // Trong ví dụ này, chúng ta tập trung vào dữ liệu gửi lên backend.
  // Các trường như 'type', 'icon', 'iconColor' không trực tiếp ánh xạ tới backend của bạn.
  // 'type' có thể được suy ra từ 'isIncome' hoặc tên danh mục.
  // 'icon' và 'iconColor' thường được quyết định bởi frontend dựa trên 'categoryId' hoặc 'isIncome'.

  Transaction({
    required this.amount,
    required this.date, // Tương ứng với transactionDate
    required this.note,
    required this.isIncome,
    required this.userId,
    required this.categoryId,
  });

  // Phương thức chuyển đổi đối tượng Transaction thành JSON để gửi lên API POST
  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'transactionDate': date.toIso8601String().split('T')[0], // Định dạng YYYY-MM-DD
      'note': note,
      'transactionType': isIncome? 'Income': 'Expense',
      'userId': userId, // Gửi userId trong một đối tượng lồng ghép
      'categoryId': categoryId, // Gửi categoryId trong một đối tượng lồng ghép
    };
  }

  // Tùy chọn: constructor fromJson nếu bạn muốn parse lại Transaction từ phản hồi API
  // (ví dụ: khi backend trả về Transaction đã được lưu với ID)
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      amount: json['amount'].toDouble(),
      date: DateTime.parse(json['transactionDate']),
      note: json['note'],
      isIncome: json['isIncome'],
      userId: json['user']['userId'],
      categoryId: json['category']['categoryId'],
    );
  }
}