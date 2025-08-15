import 'package:flutter/widgets.dart';

class Category {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final String type; // Income hoặc Expense

  Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.type,
  });

  Category copyWith({String? name, IconData? icon, Color? color}) {
    return Category(
      id: id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      type: type, // không cho sửa type
    );
  }

  
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['categoryID'].toString(),
      name: json['categoryName'],
      icon: IconData(json['iconCode'], fontFamily: 'MaterialIcons'),
      color: Color(int.parse(json['colorCode'].replaceFirst('#', '0xff'))),
      type: json['type'],
    );
  }
}