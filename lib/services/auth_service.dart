import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:edu_lab/entities/token.dart';
import 'package:edu_lab/utils/api_client.dart';
import 'package:edu_lab/utils/response.dart';
import 'package:edu_lab/utils/token_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  var apiClient = ApiClient();

  Future<ApiResponse> login(String email, String password) async {
    try {
      final response = await apiClient.dio.post(
        '/Auth/login',
        data: jsonEncode({'email': email, 'password': password}),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        var apiResponse = ApiResponse.fromJson(json.decode(response.data));
        var token = Token.fromJson(apiResponse.data);
        TokenStorage.saveTokens(token);
        return apiResponse;
      } else {
        return ApiResponse.fromError('Failed to login');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<ApiResponse> register(String email, String password) async {
    try {
      final response = await apiClient.dio.post(
        '/Auth/register',
        data: jsonEncode({'email': email, 'password': password}),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        var apiResponse = ApiResponse.fromJson(json.decode(response.data));
        var token = Token.fromJson(apiResponse.data);
        TokenStorage.saveTokens(token);
        return apiResponse;
      } else {
        return ApiResponse.fromError('Failed to register');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<ApiResponse> logout() async {
    try {
      var token = await getToken();

      final response = await apiClient.dio.post(
        '/Auth/logout', // Replace with your logout endpoint
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token', // Add the Bearer token here
          },
        ),
      );
      if (response.statusCode == 200) {
        TokenStorage.clearTokens();
        return ApiResponse.fromJson(json.decode(response.data));
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
      final response = await apiClient.dio.post(
        '/Auth/get-info', // Replace with your logout endpoint
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token', // Add the Bearer token here
          },
        ),
      );
      if (response.statusCode == 200) {
        return ApiResponse.fromJson(json.decode(response.data));
      } else {
        return ApiResponse.fromError('Failed to get user info');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> getToken() async {
    var token = await TokenStorage.getAccessToken();
    if (token == null) {
      throw Exception('Token is null');
    }
    return token;
  }
}
