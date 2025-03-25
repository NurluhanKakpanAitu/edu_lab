import 'package:edu_lab/entities/test/test_result.dart';
import 'package:edu_lab/utils/api_client.dart';
import 'package:edu_lab/utils/response.dart';

class TestService {
  final ApiClient _apiClient = ApiClient();

  Future<ApiResponse> getTestsByModuleId(String moduleId) async {
    try {
      final response = await _apiClient.dio.get('/Test/module/$moduleId/tests');
      if (response.statusCode == 200) {
        return ApiResponse.fromJson(response.data);
      } else {
        return ApiResponse.fromError('Failed to fetch tests');
      }
    } catch (e) {
      return ApiResponse.fromError('Failed to fetch tests');
    }
  }

  Future<ApiResponse> getPracticeWork(String moduleId) async {
    try {
      final response = await _apiClient.dio.get(
        '/Test/module/$moduleId/practice-works',
      );
      if (response.statusCode == 200) {
        return ApiResponse.fromJson(response.data);
      } else {
        return ApiResponse.fromError('Failed to fetch practice work');
      }
    } catch (e) {
      return ApiResponse.fromError('Failed to fetch practice work');
    }
  }

  Future<ApiResponse> submitPracticeWork(
    String practiceWorkId,
    String code,
  ) async {
    try {
      final response = await _apiClient.dio.post(
        '/Test/practice-work-result',
        data: {'code': code, 'practiceWorkId': practiceWorkId},
      );
      if (response.statusCode == 200) {
        return ApiResponse.fromJson(response.data);
      } else {
        return ApiResponse.fromError('Failed to submit practice work');
      }
    } catch (e) {
      return ApiResponse.fromError('Failed to submit practice work');
    }
  }

  Future<ApiResponse> submitTest(
    String testId,
    List<TestResult> answers,
  ) async {
    try {
      final response = await _apiClient.dio.post(
        '/Test/test-result',
        data: {
          'testId': testId,
          'results': answers.map((e) => e.toJson()).toList(),
        },
      );
      if (response.statusCode == 200) {
        return ApiResponse.fromJson(response.data);
      } else {
        return ApiResponse.fromError('Failed to submit test');
      }
    } catch (e) {
      return ApiResponse.fromError('Failed to submit test');
    }
  }

  Future<ApiResponse> addTest(Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.dio.post('/Test', data: data);
      if (response.statusCode == 200) {
        return ApiResponse.fromJson(response.data);
      } else {
        return ApiResponse.fromError('Failed to add test');
      }
    } catch (e) {
      return ApiResponse.fromError('Failed to add test');
    }
  }
}
