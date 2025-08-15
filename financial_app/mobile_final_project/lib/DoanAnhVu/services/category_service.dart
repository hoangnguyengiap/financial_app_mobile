// lib/DoanAnhVu/services/category_service.dart (Tạo file mới)
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:final_project/DoanAnhVu/DTO/CategorySimpleDTO.dart';
import 'package:final_project/global_variable/ip_address.dart'; // Đảm bảo đường dẫn đúng

class CategoryService {
  final String baseUrl = 'http://$currentHost/api/categories'; // Endpoint của CategoryController

  Future<List<CategorySimpleDTO>> getIncomeCategories(int userID) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/income?userID=$userID'));

      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body);
        List<CategorySimpleDTO> categories = body
            .map((dynamic item) => CategorySimpleDTO.fromJson(item))
            .toList();
        return categories;
      } else {
        throw Exception('Failed to load income categories: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server or parse income categories: $e');
    }
  }

  Future<List<CategorySimpleDTO>> getExpenseCategories(int userID) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/expense?userID=$userID'));

      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body);
        List<CategorySimpleDTO> categories = body
            .map((dynamic item) => CategorySimpleDTO.fromJson(item))
            .toList();
        return categories;
      } else {
        throw Exception('Failed to load expense categories: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server or parse expense categories: $e');
    }
  }
}