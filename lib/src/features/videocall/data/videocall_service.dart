import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../../../utils/constants/api.dart';

class VideocallService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<void> createHelpRequest({
    required int idSkill,
  }) async {
    final idUser = await _secureStorage.read(key: 'id_user');
    final token = await _secureStorage.read(key: 'jwt_token');

    print('ID Profile: $idUser');
    print('Token: $token');
    if (token == null || idUser == null) {
      throw Exception('Token o idProfile no encontrados');
    }

    final idProfile = int.parse(idUser);

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
}
