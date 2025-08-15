class AvailableCategory {
  final int categoryId;
  final String name;

  AvailableCategory({
    required this.categoryId,
    required this.name,
  });

  factory AvailableCategory.fromJson(Map<String, dynamic> json) {
    return AvailableCategory(
      categoryId: json['categoryId'] as int,
      name: json['name'] as String,
    );
  }
  
}
