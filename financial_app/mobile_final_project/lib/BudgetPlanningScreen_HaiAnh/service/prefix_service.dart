import 'dart:convert';

import 'package:final_project/global_variable/ip_address.dart';
import 'package:final_project/model/AvailableCategory.dart';
import 'package:final_project/model/Prefix.dart';
import 'package:http/http.dart' as http;

class prefix_service{
  Future<List<AvailableCategory>> getAvailableCategory(int userID) async {
    final url = Uri.http(currentHost, "/api/categories/simpleCategoryForPrefix", {
      'userID': userID.toString(),
    });

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      print("Get categories successfully!");
      return data.map((json) => AvailableCategory.fromJson(json)).toList();
    } else {
      print("Failed to get available categories");
      throw Exception('Failed to delete budget');
    }
  }

  Future<String> addPrefix(int userID, int catID, double amount) async {
    final url = Uri.http(currentHost, "/api/prefix/insert", 
      {
        'cateID': catID.toString(),
        'userID': userID.toString(),
        'amount': amount.toString(),
      }
    );

    final response = await http.post(url);

    if (response.statusCode == 200) {
      print("New prefix added successfully!");
      return ("New prefix added successfully!");
    } else {
      print("Failed adding new prefix");
      throw Exception('Failed to add new prefix');
    }
  }

  Future<List<Prefix>> getPrefixList(int id) async {
    final url = Uri.http(currentHost, "/api/prefix/show",
      {
        'userID': id.toString(),
      },
    );
    
    print("Data is being fetch...");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      print("Success!");
      return data.map((json) => Prefix.fromJson(json)).toList();
    } else {
      print("Failed");
      throw Exception('Failed to fetch budgets');
    }
  }

  Future<String> deletePrefix(int id) async{
    final url = Uri.http(currentHost, "/api/prefix/delete", {'id': id.toString()});

    final response = await http.delete(url);

    if (response.statusCode == 200) {
      print("Prefix deleted successfully!");
      return ("Prefix deleted successfully!");
    } else {
      print("Failed");
      throw Exception('Failed to delete prefix');
    }
  }

  Future<String> applyPrefix(int id, int month, int year) async {
    final url = Uri.http(currentHost, "/api/prefix/applyPrefix", {
      'userID': id.toString(),
      'month': month.toString(),
      'year': year.toString()
    });

    final response = await http.post(url);

    if (response.statusCode == 200) {
      print("Prefix applied successfully!");
      return ("Prefix applied successfully!");
    } else {
      print("Failed");
      throw Exception('Failed to apply prefix');
    }
  }
}