import 'package:edu_lab/utils/api_client.dart';
import 'package:edu_lab/utils/response.dart';

class CourseService {
  var apiClient = ApiClient();

  Future<ApiResponse> getCourses() async {
    try {
      var response = await apiClient.dio.get('/Course/all');

      if (response.statusCode == 200) {
        return ApiResponse.fromJson(response.data);
      } else {
        return ApiResponse.fromError('Failed to fetch courses');
      }
    } catch (e) {
      return ApiResponse.fromError('Failed to fetch courses');
    }
  }
}
