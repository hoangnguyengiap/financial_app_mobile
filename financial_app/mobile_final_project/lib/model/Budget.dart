class Budget {
  final int budgetId;
  final int userId;
  final int categoryId;
  final String categoryName;
  final int iconCode;
  double amount;
  final double spentAmount;
  final int month;
  final int year;

  Budget({
    required this.budgetId,
    required this.userId,
    required this.categoryId,
    required this.categoryName,
    required this.iconCode,
    required this.amount,
    required this.spentAmount,
    required this.month,
    required this.year,
  });

  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
      budgetId: json['budgetId'],
      userId: json['userId'],
      categoryId: json['categoryId'],
      categoryName: json['categoryName'],
      iconCode: json['iconCode'],
      amount: (json['amount'] as num).toDouble(),
      spentAmount: (json['spentAmount'] as num).toDouble(),
      month: json['month'],
      year: json['year'],
    );
  }
  
}
