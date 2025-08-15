import 'dart:convert';

import 'package:final_project/global_variable/ip_address.dart';
import 'package:final_project/model/User.dart';
import 'package:http/http.dart' as http;

class login_service{
  Future<User?> login(String email, String password) async {
    final url = Uri.http(currentHost, "/api/user/login");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password
      }),
    );

    if(response.statusCode == 200){
      print("Login successfuly!");
      final result = jsonDecode(response.body);
      return User.fromJson(result);
    }else{
      print("Failed to login: " + response.statusCode.toString());
      return null;
    }
  }

  Future<User?> register(String email, String username, String password) async {
    final url = Uri.http(currentHost, "/api/user/register");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "username": username,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      print("Register successfully! Logging in...");
      final result = jsonDecode(response.body);
      return User.fromJson(result);
    } else {
      final error = jsonDecode(response.body);
      final message = error['message'] ?? 'Unknown error occurred';
      print("Registration failed: $message");

      // Optionally, throw the error message to be caught in UI
      throw Exception(message);
    }
  }
}