import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../../../common/exceptions/api_exception.dart';
import '../../../common/utils/constants/api.dart';
import '../domain/videocall_response.dart';

class VideocallService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<int> createHelpRequest({
    required int idSkill,
  }) async {
    final idUser = await _secureStorage.read(key: 'id_user');
    final token = await _secureStorage.read(key: 'jwt_token');
    final deviceToken = await _secureStorage.read(key: 'device_token');

    if (token == null || idUser == null) {
      throw ApiException(401, 'Credenciales no disponibles');
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
        'tokenDevice': deviceToken,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw ApiException(response.statusCode, response.body);
    }

    final data = jsonDecode(response.body);
    return data['idRequest'];
  }

  Future<void> cancelRequest(idRequest) async {
    final token = await const FlutterSecureStorage().read(key: 'jwt_token');
    final url = Uri.parse('$baseUrl/requests/cancel/$idRequest');

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Error al cancelar la solicitud');
      }

      debugPrint('Solicitud cancelada correctamente.');
    } catch (e) {
      debugPrint('Error al cancelar solicitud: $e');
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

  Future<void> endVideocall(String channel) async {
    final token = await _secureStorage.read(key: 'jwt_token');
    print('Token: $token');
    if (token == null) {
      throw Exception('Token no encontrado');
    }

    try {
      final url = Uri.parse('$baseUrl/videocalls/end');
      await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({'channel': channel}));
    } catch (e) {
      debugPrint('Error al finalizar videollamada: $e');
    }
  }
}
