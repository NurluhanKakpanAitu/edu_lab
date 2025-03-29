import 'dart:io';
import 'package:dio/dio.dart';
import 'package:edu_lab/utils/api_response.dart';
import 'package:http/http.dart' as http;

class FileService {
  final String baseUrl = 'http://localhost:5148/api/File';
  final Dio _dio = Dio();

  /// Uploads a file to MinIO storage.
  /// Returns the public URL of the uploaded file.
  Future<ApiResponse> uploadFile(File file) async {
    try {
      String fileName = file.path.split('/').last;
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(file.path, filename: fileName),
      });

      Response response = await _dio.post(
        '$baseUrl/upload',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      if (response.statusCode == 200) {
        return ApiResponse.fromJson(response.data);
      } else {
        return ApiResponse.fromError('Failed to upload file');
      }
    } catch (e) {
      return ApiResponse.fromError('Failed to upload file');
    }
  }

  /// Downloads a file from MinIO storage and saves it locally.
  Future<File?> downloadFile(String objectName, String savePath) async {
    try {
      var response = await http.get(Uri.parse('$baseUrl/download/$objectName'));

      if (response.statusCode == 200) {
        File file = File(savePath);
        await file.writeAsBytes(response.bodyBytes);
        return file;
      } else {
        throw Exception('Failed to download file');
      }
    } catch (e) {
      return null;
    }
  }
}
