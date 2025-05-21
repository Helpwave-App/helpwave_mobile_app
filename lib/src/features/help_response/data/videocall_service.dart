import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../../../utils/constants/api.dart';
import '../domain/videocall_response.dart';

class VideocallService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<void> createHelpRequest({
    required int idSkill,
  }) async {
    final idUser = await _secureStorage.read(key: 'id_user');
    final token = await _secureStorage.read(key: 'jwt_token');
    final deviceToken = await _secureStorage.read(key: 'device_token');

    print('ID Profile: $idUser');
    print('Token: $token');
    if (token == null || idUser == null) {
      throw Exception('Token o idProfile no encontrados');
    }

    final idProfile = int.parse(idUser);

    print('📤 Enviando solicitud con:');
    print('idProfile: $idProfile');
    print('idSkill: $idSkill');
    print('stateRequest: true');
    print('tokenDevice: $deviceToken');

    final url = Uri.parse('$baseUrl/requests');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'idProfile': idProfile,
        'idSkill': idSkill,
        'stateRequest': true,
        'tokenDevice': deviceToken,
      }),
    );

    if (kDebugMode) {
      print('→ POST $url');
      print('← Status: ${response.statusCode}');
      print('← Response: ${response.body}');
    }

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Error al crear la solicitud: ${response.body}');
    }
  }

  Future<VideocallResponse> acceptEmpairing(int idEmpairing) async {
    final token = await _secureStorage.read(key: 'jwt_token');
    try {
      final url = Uri.parse('$baseUrl/empairings/accept/$idEmpairing');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return VideocallResponse.fromJson(data);
      } else {
        throw Exception('Failed to accept empairing: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al aceptar emparejamiento: $e');
    }
  }
}
