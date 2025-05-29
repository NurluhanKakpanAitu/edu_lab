import 'package:edu_lab/entities/token.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Storage {
  static const _storage = FlutterSecureStorage();

  static Future<void> saveTokens(Token token) async {
    await _storage.write(key: 'access_token', value: token.accessToken);
    await _storage.write(key: 'refresh_token', value: token.refreshToken);
  }

  static Future<String?> getAccessToken() async {
    try {
      return await _storage.read(key: 'access_token');
    } catch (e) {
      print('Ошибка при чтении access_token: $e');
      await _storage.delete(key: 'access_token');
      return null;
    }
  }

  static Future<String?> getRefreshToken() async {
    try {
      return await _storage.read(key: 'refresh_token');
    } catch (e) {
      print('Ошибка при чтении refresh_token: $e');
      await _storage.delete(key: 'refresh_token');
      return null;
    }
  }

  static Future<void> clearTokens() async {
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
  }

  static Future<int> getRole() async {
    try {
      final role = await _storage.read(key: 'role');
      return role == null ? 2 : int.parse(role);
    } catch (e) {
      print('Ошибка при чтении роли: $e');
      await _storage.delete(key: 'role');
      return 2; // значение по умолчанию
    }
  }

  static Future<void> saveRole(int role) async {
    await _storage.write(key: 'role', value: role.toString());
  }
}
