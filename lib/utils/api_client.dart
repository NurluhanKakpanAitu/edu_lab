import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:edu_lab/entities/token.dart';
import 'package:edu_lab/utils/token_storage.dart';

class ApiClient {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://localhost:5148/api',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );

  ApiClient() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await TokenStorage.getAccessToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            // Attempt to refresh token
            final success = await _refreshToken();
            if (success) {
              final newToken = await TokenStorage.getAccessToken();
              e.requestOptions.headers['Authorization'] = 'Bearer $newToken';

              // Retry the request with the new token
              return handler.resolve(await _dio.fetch(e.requestOptions));
            }
          }
          return handler.next(e);
        },
      ),
    );
  }

  Dio get dio => _dio;

  Future<bool> _refreshToken() async {
    final refreshToken = await TokenStorage.getRefreshToken();
    if (refreshToken == null) return false;

    try {
      final response = await _dio.post('/Auth/refresh-token/$refreshToken');

      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.data);
        var token = Token.fromJson(decodedData);

        await TokenStorage.saveTokens(token);
        return true;
      }
    } catch (e) {
      await TokenStorage.clearTokens();
    }
    return false;
  }
}
