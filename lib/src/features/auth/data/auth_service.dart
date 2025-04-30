import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../../../constants/api.dart';
import '../domain/login_request_model.dart';
import 'auth_response.dart';

class AuthService {
  Future<bool> registerUser({
    required String username,
    required String password,
    required String name,
    required String lastName,
    required int roleId, // 1 o 2
  }) async {
    final url = Uri.parse('$baseUrl/user/register');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
        'state': true,
        'idRole': roleId,
        'profile': {
          'name': name,
          'lastName': lastName,
          'scoreProfile': 0.0,
        }
      }),
    );

    if (kDebugMode) {
      print('Register response: ${response.statusCode} - ${response.body}');
    }

    return response.statusCode == 200;
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
}
