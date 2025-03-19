import 'dart:convert';

import 'package:edu_lab/services/auth_service.dart';
import 'package:http/http.dart' as http;

class UserService {
  final String baseUrl =
      'http://localhost:5148/api/User'; // Replace with your backend URL

  var authService = AuthService();
  Future<Map<String, dynamic>> updateProfile(
    String id,
    String nickname,
    String email,
    String about,
    String? photoPath,
    String? password,
  ) async {
    try {
      var token = await authService.getToken();
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'nickname': nickname,
          'email': email,
          'about': about,
          'photoPath': photoPath,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to update profile');
      }
    } catch (e) {
      rethrow;
    }
  }
}
