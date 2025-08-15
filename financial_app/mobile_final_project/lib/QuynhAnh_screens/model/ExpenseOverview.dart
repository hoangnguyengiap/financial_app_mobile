import 'package:final_project/global_variable/number_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ExpenseOverview {
  String amount;
  String name;
  Color color;

  ExpenseOverview ({required this.amount, required this.name, required this.color});

  factory ExpenseOverview.fromJson(Map<String, dynamic> json) {
    return ExpenseOverview(
      name: json['categoryName'],
      amount: json['totalSpent'].toString(),
      color: (json['colorCode'] != null)?
      Color(int.parse(json['colorCode'].replaceFirst('#', '0xff'))) : Colors.white
    );
  }
}


