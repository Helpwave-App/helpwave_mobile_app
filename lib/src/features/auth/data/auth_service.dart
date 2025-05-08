import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import '../../../utils/api.dart';
import '../../../utils/secure_storage.dart';
import '../domain/login_request_model.dart';
import 'auth_response.dart';

class AuthService {
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
    final sanitizedUsername = username.trim(); // <-- quita espacios
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
      return AuthResponse.fromJson(data);
    } else {
      throw Exception('Credenciales inválidas');
    }
  }

  Future<void> logout() async {
    await SecureStorage.deleteToken();
  }
}
