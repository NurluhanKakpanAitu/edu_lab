import 'package:dio/dio.dart';
import 'package:edu_lab/entities/requests/course_request.dart';
import 'package:edu_lab/entities/requests/module_request.dart';
import 'package:edu_lab/utils/api_client.dart';
import 'package:edu_lab/utils/api_response.dart';

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

  Future<ApiResponse> addCourse(CourseRequest request) async {
    try {
      var response = await apiClient.dio.post(
        '/Course',
        data: request.toJson(),
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

  Future<ApiResponse> addModule(ModuleRequest request) async {
    try {
      var response = await apiClient.dio.post(
        '/Module',
        data: request.toJson(),
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

  Future<ApiResponse> deleteCourse(String id) async {
    try {
      var response = await apiClient.dio.delete('/Course/$id');

      if (response.statusCode == 200) {
        return ApiResponse.fromJson(response.data);
      } else {
        return ApiResponse.fromError('Failed to delete course');
      }
    } catch (e) {
      return ApiResponse.fromError('Failed to delete course');
    }
  }

  Future<ApiResponse> updateCourse(String id, CourseRequest request) async {
    try {
      var response = await apiClient.dio.put(
        '/Course/$id',
        data: request.toJson(),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        return ApiResponse.fromJson(response.data);
      } else {
        return ApiResponse.fromError('Failed to update course');
      }
    } catch (e) {
      return ApiResponse.fromError('Failed to update course');
    }
  }

  Future<ApiResponse> updateModule(String id, ModuleRequest request) async {
    try {
      var response = await apiClient.dio.put(
        '/Module/$id',
        data: request.toJson(),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        return ApiResponse.fromJson(response.data);
      } else {
        return ApiResponse.fromError('Failed to update module');
      }
    } catch (e) {
      return ApiResponse.fromError('Failed to update module');
    }
  }

  Future<ApiResponse> deleteModule(String id) async {
    try {
      var response = await apiClient.dio.delete('/Module/$id');

      if (response.statusCode == 200) {
        return ApiResponse.fromJson(response.data);
      } else {
        return ApiResponse.fromError('Failed to delete module');
      }
    } catch (e) {
      return ApiResponse.fromError('Failed to delete module');
    }
  }

  Future<ApiResponse> getModule(String moduleId) async {
    try {
      var response = await apiClient.dio.get('/Module/$moduleId');

      if (response.statusCode == 200) {
        return ApiResponse.fromJson(response.data);
      } else {
        return ApiResponse.fromError('Failed to fetch modules');
      }
    } catch (e) {
      return ApiResponse.fromError('Failed to fetch modules');
    }
  }
}
