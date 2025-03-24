import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:edu_lab/utils/api_client.dart';
import 'package:edu_lab/utils/response.dart';

class UserService {
  var apiClient = ApiClient();

  Future<ApiResponse> updateProfile(
    String id,
    String nickname,
    String email,
    String about,
    String? photoPath,
    String? password,
  ) async {
    try {
      final response = await apiClient.dio.put(
        '/User/$id',
        data: jsonEncode({
          'nickname': nickname,
          'email': email,
          'about': about,
          'photoPath': photoPath,
          'password': password,
        }),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        return ApiResponse.fromJson(response.data);
      } else {
        return ApiResponse.fromError('Failed to update profile');
      }
    } catch (e) {
      return ApiResponse.fromError('Failed to update profile');
    }
  }

  Future<ApiResponse> getTestResult(String testId) async {
    try {
      final response = await apiClient.dio.get(
        '/User/$testId/test-result',
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        return ApiResponse.fromJson(response.data);
      } else {
        return ApiResponse.fromError('Failed to get test result');
      }
    } catch (e) {
      return ApiResponse.fromError('Failed to get test result');
    }
  }
}
