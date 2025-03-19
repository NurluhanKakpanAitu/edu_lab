import 'dart:convert';

import 'package:edu_lab/utils/response.dart';
import 'package:http/http.dart' as http;

class CourseService {
  final String baseUrl = 'http://localhost:5148/api/Course';

  Future<ApiResponse> getCourses() async {
    try {
      var response = await http.get(Uri.parse('$baseUrl/all'));

      if (response.statusCode == 200) {
        return ApiResponse.fromJson(json.decode(response.body));
      } else {
        return ApiResponse.fromError('Failed to fetch courses');
      }
    } catch (e) {
      return ApiResponse.fromError('Failed to fetch courses');
    }
  }
}
