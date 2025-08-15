// lib/DoanAnhVu/DTO/CategorySimpleDTO.dart (Tạo file mới)

class CategorySimpleDTO {
  final int categoryId;
  final String categoryName;
  final int iconCode;
  final String iconColor; // Assuming iconColor is a hex string or similar

  CategorySimpleDTO({
    required this.categoryId,
    required this.categoryName,
    required this.iconCode,
    required this.iconColor,
  });

  factory CategorySimpleDTO.fromJson(Map<String, dynamic> json) {
  return CategorySimpleDTO(
    categoryId: json['categoryId'] ?? 0,
    categoryName: json['categoryName']?.toString() ?? 'Unknown',
    iconCode: json['iconCode'] ?? 0,
    iconColor: json['colorCode']?.toString() ?? '#000000',
  );
}
}