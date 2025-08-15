import 'dart:convert';
import 'package:final_project/QuynhAnh_screens/model/ExpenseOverview.dart';
import 'package:final_project/QuynhAnh_screens/model/Summary.dart';
import 'package:final_project/global_variable/ip_address.dart';
import 'package:final_project/model/AvailableCategory.dart';
import 'package:final_project/model/Budget.dart';
import 'package:http/http.dart' as http;

class ExpenseOverview_service{

  Future<List<ExpenseOverview>> showtop3ExOverview(int id, int month, int year) async {
    final url = Uri.http(currentHost, "/api/monthlyreport/top3MonthlyExpense",
      {
        'userID': id.toString(),
        'month': month.toString(),
        'year': year.toString(),
      },
    );
    
    print("Data is being fetch...");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      print("Successfully retrieving top 3 expense!");
      return data.map((json) => ExpenseOverview.fromJson(json)).toList();
    } else {
      print("Failed to retrieve top 3 expense!");
      throw Exception('Failed to fetch top3 expense overview');
    }
  }

  Future<Summary> showSummary(int id, int month, int year) async {
    final url = Uri.http(currentHost, "/api/monthlyreport/monthlySummary",
      {
        'userID': id.toString(),
        'month': month.toString(),
        'year': year.toString(),
      },
    );
    
    print("Data is being fetch...");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String ,dynamic> data = jsonDecode(response.body);
      print("Successfully retrieving monthly summary!");
      return Summary.fromJson(data);
    } else {
      print("Failed to retrieve monthly summary!");
      throw Exception('Failed to fetch overview');
    }
    
  }
  Future<List<ExpenseOverview>> showExpensebyCategory(int id, int month, int year) async {
    final url = Uri.http(currentHost, "/api/monthlyreport/monthlyExpense",
      {
        'userID': id.toString(),
        'month': month.toString(),
        'year': year.toString(),
      },
    );
    
    print("Data is being fetch...");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      print("Successfully retrieving full monthly expense!");
      return data.map((json) => ExpenseOverview.fromJson(json)).toList();
    } else {
      print("Failed to retrieve full monthly expense!");
      throw Exception('Failed to fetch expense by category');
    }


  }}