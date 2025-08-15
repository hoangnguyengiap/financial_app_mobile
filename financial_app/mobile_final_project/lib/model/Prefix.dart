class Prefix {
  final int prefixId;
  final double amount;
  final int categoryId;
  final String categoryName;
  final int userId;

  Prefix({
    required this.prefixId,
    required this.amount,
    required this.categoryId,
    required this.categoryName,
    required this.userId,
  });

  factory Prefix.fromJson(Map<String, dynamic> json) {
    return Prefix(
      prefixId: json['prefixId'],
      amount: (json['amount'] as num).toDouble(),
      categoryId: json['categoryId'],
      categoryName: json['categoryName'],
      userId: json['userId'],
    );
  }
}
