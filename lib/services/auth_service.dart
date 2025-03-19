import 'dart:convert';
import 'package:edu_lab/entities/user_get_info.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl =
      'http://localhost:5148/api/Auth'; // Replace with your backend URL

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        var token = json.decode(response.body)['data'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        return json.decode(response.body);
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error during login: $e');
      }
      rethrow;
    }
  }

  Future<Map<String, dynamic>> register(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        var token = json.decode(response.body)['data'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        return json.decode(response.body);
      } else {
        throw Exception('Failed to register');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> logout() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/logout'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to logout');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<UserGetInfo> getUser() async {
    try {
      var token = await getToken();
      final response = await http.get(
        Uri.parse('$baseUrl/get-info'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        var decoded = json.decode(response.body)['data'];
        return UserGetInfo.fromJson(decoded);
      } else {
        throw Exception('Failed to get user');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }
}
