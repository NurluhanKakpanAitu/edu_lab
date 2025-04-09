import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:edu_lab/utils/api_client.dart';
import 'package:edu_lab/utils/api_response.dart';
import 'package:edu_lab/utils/storage.dart';

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
        return apiResponse;
      } else {
        return ApiResponse.fromError('loginFailed');
      }
    } catch (e) {
      print(e.toString());
      return ApiResponse.fromError('loginFailed');
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
        Storage.clearTokens();
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

  Future<int> getUserRole() async {
    try {
      final response = await apiClient.dio.get(
        '/Auth/get-info',
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      if (response.statusCode == 200) {
        var apiResponse = ApiResponse.fromJson(response.data);
        Storage.saveRole(apiResponse.data['role']);
        return apiResponse.data['role'];
      } else {
        return 2;
      }
    } catch (e) {
      return 2;
    }
  }
}
