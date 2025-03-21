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
}
