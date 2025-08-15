import 'dart:convert';

import 'package:final_project/global_variable/ip_address.dart';
import 'package:final_project/model/Category.dart';
import 'package:http/http.dart' as http;

class category_service{
  Future<List<Category>> getCategoriesList(int id) async {
    final url = Uri.http(currentHost, "/api/categories/getMobileCategories",
      {
        'userID': id.toString(),
      },
    );
    
    print("Data is being fetch...");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      print("Success!");
      return data.map((json) => Category.fromJson(json)).toList();
    } else {
      print("Failed");
      throw Exception('Failed to fetch budgets');
    }
  }

  Future<String> addCategory(int userID, String name, String type, int iconCode, String colorCode) async {
    final url = Uri.http(currentHost, "/api/categories/insert", 
      {
        'userID': userID.toString(),
        'name': name,
        'type': type,
        'iconCode': iconCode.toString(),
        'colorCode': colorCode.toString()
      }
    );

    final response = await http.post(url);

    if (response.statusCode == 200) {
      print("New category added successfully!");
      return ("New category added successfully!");
    } else {
      print("Failed adding new category");
      throw Exception('Failed to add new category');
    }
  }

  Future<String> editCategory(int id, String name, int iconCode, String colorCode) async {
    final url = Uri.http(currentHost, "/api/categories/update", 
      {
        'id': id.toString(),
        'name': name,
        'iconCode': iconCode.toString(),
        'colorCode': colorCode.toString()
      }
    );

    final response = await http.put(url);

    if (response.statusCode == 200) {
      print("Category updated successfully!");
      return ("Category updated successfully!");
    } else {
      print("Failed updating Category");
      throw Exception('Failed to update Category');
    }
  }

  Future<String> deleteCategory(int id) async{
    final url = Uri.http(currentHost, "/api/categories/delete", {'id': id.toString()});

    final response = await http.delete(url);

    if (response.statusCode == 200) {
      print("Category deleted successfully!");
      return ("Category deleted successfully!");
    } else {
      print("Failed deleting Category");
      throw Exception('Failed to delete Category');
    }
  }
}