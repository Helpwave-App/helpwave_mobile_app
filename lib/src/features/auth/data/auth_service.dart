import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../../utils/constants/api.dart';
import '../../../utils/constants/secure_storage.dart';
import '../../notifications/services/device_token_service.dart';
import '../domain/login_request_model.dart';
import 'auth_response.dart';

class AuthService {
  final _secureStorage = const FlutterSecureStorage();

  Future<String?> getUserRole() async {
    return await _secureStorage.read(key: 'role');
  }

  Future<bool> isTokenValid() async {
    final token = await _secureStorage.read(key: 'jwt_token');
    if (token == null) return false;
    return !JwtDecoder.isExpired(token);
  }

  Future<bool> checkUsername(String username) async {
    final url = Uri.parse('$baseUrl/user/check-username?username=$username');
    final response = await http.get(url);
    if (kDebugMode) {
      print('→ GET $url');
      print('← Status: ${response.statusCode}');
      print('← Response: ${response.body}');
    }
    if (response.statusCode == 200) {
      return response.body.toLowerCase() == 'true';
    }
    return true;
  }

  Future<int?> getProfileIdByUsername(String username) async {
    final sanitizedUsername = username.trim();
    final url = Uri.parse('$baseUrl/profiles?username=$sanitizedUsername');
    final response = await http.get(url);

    if (kDebugMode) {
      print('→ GET $url');
      print('← Status: ${response.statusCode}');
      print('← Body: "${response.body}"');
    }

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      try {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return data['idProfile'] as int?;
      } catch (e) {
        print('❌ Error al parsear JSON del perfil: $e');
        return null;
      }
    }

    return null;
  }

  Future<Map<String, dynamic>?> registerUser(
      Map<String, dynamic> payload) async {
    final url = Uri.parse('$baseUrl/user/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    if (kDebugMode) {
      print('→ POST $url');
      print('Payload: ${jsonEncode(payload)}');
      print('← Status: ${response.statusCode}');
      print('← Response: ${response.body}');
    }

    if (response.statusCode == 200 || response.statusCode == 201) {
      try {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } catch (e) {
        print('❌ Error al parsear JSON: $e');
        return null;
      }
    }
    return null;
  }

  Future<AuthResponse> login(LoginRequest request) async {
    final deviceTokenService = DeviceTokenService();
    final url = Uri.parse('$baseUrl/authenticate');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(request.toJson()),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final authResponse = AuthResponse.fromJson(data);

      await _storeSessionData(authResponse);

      final newToken =
          await DeviceTokenService.getDeviceToken(requestPermission: false);

      if (newToken != null) {
        final oldToken = await _secureStorage.read(key: 'device_token');

        await deviceTokenService.registerDeviceToken(
          newToken: newToken,
          oldToken: oldToken,
        );

        await _secureStorage.write(key: 'device_token', value: newToken);
      }

      setupFCMTokenRefresh();

      return authResponse;
    } else {
      throw Exception('Credenciales inválidas');
    }
  }

  Future<void> _storeSessionData(AuthResponse authResponse) async {
    await SecureStorage.saveToken(authResponse.token);
    await SecureStorage.saveIdUser(authResponse.idUser);
    await SecureStorage.saveRole(authResponse.role);

    final debugToken = await SecureStorage.getToken();
    print('🧪 Token guardado y leído de SecureStorage: $debugToken');
  }

  void setupFCMTokenRefresh() {
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      final oldToken = await _secureStorage.read(key: 'device_token');
      final deviceTokenService = DeviceTokenService();

      if (newToken != oldToken) {
        await deviceTokenService.registerDeviceToken(
          newToken: newToken,
          oldToken: oldToken,
        );
        await _secureStorage.write(key: 'device_token', value: newToken);
      }
    });
  }

  Future<void> logout() async {
    await DeviceTokenService().unregisterDeviceToken();
    await FirebaseMessaging.instance.deleteToken();

    await _secureStorage.delete(key: 'device_token');
    await _secureStorage.delete(key: 'jwt_token');
    await _secureStorage.delete(key: 'id_user');
    await _secureStorage.delete(key: 'role');

    print('🔐 Todos los datos eliminados de SecureStorage y FCM');
  }
}
