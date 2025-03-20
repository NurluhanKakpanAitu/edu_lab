import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:edu_lab/entities/token.dart';
import 'package:edu_lab/utils/api_client.dart';
import 'package:edu_lab/utils/response.dart';
import 'package:edu_lab/utils/token_storage.dart';

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
        var apiResponse = ApiResponse.fromJson(response.data);
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
        var apiResponse = ApiResponse.fromJson(response.data);
        var token = Token.fromJson(apiResponse.data);
        TokenStorage.saveTokens(token);
        return apiResponse;
      } else {
        return ApiResponse.fromError('Failed to register');
      }
    } catch (e) {
      return ApiResponse.fromError('Failed to register');
    }
  }

  Future<ApiResponse> logout() async {
    try {
      final response = await apiClient.dio.post(
        '/Auth/logout', // Replace with your logout endpoint
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      if (response.statusCode == 200) {
        TokenStorage.clearTokens();
        return ApiResponse.fromJson(response.data);
      } else {
        return ApiResponse.fromError('Failed to logout');
      }
    } catch (e) {
      return ApiResponse.fromError('Failed to logout');
    }
  }

  Future<ApiResponse> getUser() async {
    try {
      final response = await apiClient.dio.get(
        '/Auth/get-info',
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      if (response.statusCode == 200) {
        return ApiResponse.fromJson(response.data);
      } else {
        return ApiResponse.fromError('Failed to get user info');
      }
    } catch (e) {
      return ApiResponse.fromError('Failed to get user info');
    }
  }
}
