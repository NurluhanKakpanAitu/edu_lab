import 'package:edu_lab/entities/token.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Storage {
  static const _storage = FlutterSecureStorage();

  static Future<void> saveTokens(Token token) async {
    await _storage.write(key: 'access_token', value: token.accessToken);
    await _storage.write(key: 'refresh_token', value: token.refreshToken);
  }

  static Future<String?> getAccessToken() async {
    return await _storage.read(key: 'access_token');
  }

  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: 'refresh_token');
  }

  static Future<void> clearTokens() async {
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
  }

  static Future<int> getRole() async {
    final role = await _storage.read(key: 'role');
    return role == null ? 2 : int.parse(role);
  }

  static Future<void> saveRole(int role) async {
    await _storage.write(key: 'role', value: role.toString());
  }
}
