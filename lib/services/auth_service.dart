import 'dart:convert';
import 'package:edu_lab/utils/response.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl =
      'http://localhost:5148/api/Auth'; // Replace with your backend URL

  Future<ApiResponse> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        var token = ApiResponse.fromJson(json.decode(response.body)).data;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        return ApiResponse.fromJson(json.decode(response.body));
      } else {
        return ApiResponse.fromError('Failed to login');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<ApiResponse> register(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        var token = ApiResponse.fromJson(json.decode(response.body)).data;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        return ApiResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to register');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<ApiResponse> logout() async {
    try {
      var token = await getToken();
      final response = await http.post(
        Uri.parse('$baseUrl/logout'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('token');
        return ApiResponse.fromJson(json.decode(response.body));
      } else {
        return ApiResponse.fromError('Failed to logout');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<ApiResponse> getUser() async {
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
        return ApiResponse.fromJson(json.decode(response.body));
      } else {
        return ApiResponse.fromError('Failed to get user info');
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
