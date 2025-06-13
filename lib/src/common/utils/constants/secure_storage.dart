import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const _storage = FlutterSecureStorage();

  // TOKEN
  static Future<void> saveToken(String token) async {
    await _storage.write(key: 'jwt_token', value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  static Future<void> deleteToken() async {
    await _storage.delete(key: 'jwt_token');
  }

  // ID USER
  static Future<void> saveIdUser(int idUser) async {
    await _storage.write(key: 'id_user', value: idUser.toString());
  }

  static Future<String?> getIdUser() async {
    return await _storage.read(key: 'id_user');
  }

  static Future<void> deleteIdUser() async {
    await _storage.delete(key: 'id_user');
  }

  // ROLE
  static Future<void> saveRole(String role) async {
    await _storage.write(key: 'role', value: role);
  }

  static Future<String?> getRole() async {
    return await _storage.read(key: 'role');
  }

  static Future<void> deleteRole() async {
    await _storage.delete(key: 'role');
  }
}
