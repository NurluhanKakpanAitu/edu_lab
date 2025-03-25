import 'package:dio/dio.dart';
import 'package:edu_lab/entities/course/add_course.dart';
import 'package:edu_lab/entities/course/add_module.dart';
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

  Future<ApiResponse> getCourse(String id) async {
    try {
      var response = await apiClient.dio.get('/Course/$id');

      if (response.statusCode == 200) {
        return ApiResponse.fromJson(response.data);
      } else {
        return ApiResponse.fromError('Failed to fetch course');
      }
    } catch (e) {
      return ApiResponse.fromError('Failed to fetch course');
    }
  }

  Future<ApiResponse> addCourse(AddCourse addCourseModal) async {
    try {
      var response = await apiClient.dio.post(
        '/Course',
        data: addCourseModal.toJson(),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        return ApiResponse.fromJson(response.data);
      } else {
        return ApiResponse.fromError('Failed to add course');
      }
    } catch (e) {
      return ApiResponse.fromError('Failed to add course');
    }
  }

  Future<ApiResponse> addModule(AddModule module) async {
    try {
      var response = await apiClient.dio.post(
        '/Module',
        data: module.toJson(),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        return ApiResponse.fromJson(response.data);
      } else {
        return ApiResponse.fromError('Failed to add module');
      }
    } catch (e) {
      return ApiResponse.fromError('Failed to add module');
    }
  }
}
