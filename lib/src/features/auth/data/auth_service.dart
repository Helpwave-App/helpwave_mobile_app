import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../../utils/constants/api.dart';
import '../../../utils/constants/secure_storage.dart';
import '../../notifications/services/device_token_service.dart';
import '../domain/login_request_model.dart';
import 'auth_response.dart';

class AuthService {
  Future<String?> getUserRole() async {
    return await SecureStorage.getRole();
  }

  Future<bool> isTokenValid() async {
    final token = await SecureStorage.getToken();
    if (token == null) {
      return false;
    }
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
        if (kDebugMode) {
          print('❌ Error al parsear JSON del perfil: $e');
        }
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
        if (kDebugMode) {
          print('Error al parsear JSON: $e');
        }
        return null;
      }
    } else {
      return null;
    }
  }

  Future<AuthResponse> login(LoginRequest request) async {
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

      final token =
          await DeviceTokenService.getDeviceToken(requestPermission: true);
      if (token != null) {
        await DeviceTokenService.registerDeviceToken(token: token);
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
  }

  void setupFCMTokenRefresh() {
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      await DeviceTokenService.registerDeviceToken(token: newToken);
    });
  }

  Future<void> logout() async {
    await SecureStorage.deleteToken();
    await SecureStorage.deleteRole();
    await SecureStorage.deleteIdUser();
  }
}
