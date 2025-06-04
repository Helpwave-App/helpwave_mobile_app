import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../../../utils/constants/api.dart';
import '../domain/level_progress.dart';

class LevelService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<LevelProgressModel> getLevelProgress(int idProfile) async {
    final idUser = await _secureStorage.read(key: 'id_user');
    final token = await _secureStorage.read(key: 'jwt_token');

    if (token == null || idUser == null) {
      throw Exception('Token o idProfile no encontrados');
    }

    final url = Uri.parse('$baseUrl/levels/progress/$idProfile');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Error al registrar comentario: ${response.body}');
    }
    return LevelProgressModel.fromJson(jsonDecode(response.body));
  }
}
