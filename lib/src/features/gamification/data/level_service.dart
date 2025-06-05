import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../../../common/utils/constants/api.dart';
import '../domain/level_model.dart';
import '../domain/level_progress.dart';

class LevelService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<LevelProgressModel> getLevelProgress() async {
    final idUser = await _secureStorage.read(key: 'id_user');
    final token = await _secureStorage.read(key: 'jwt_token');

    if (token == null || idUser == null) {
      throw Exception('Token o idProfile no encontrados');
    }

    final url = Uri.parse('$baseUrl/levels/progress/$idUser');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Error al obtener stats: ${response.body}');
    }
    return LevelProgressModel.fromJson(jsonDecode(response.body));
  }

  Future<Level> fetchLevel(int idLevel) async {
    final idUser = await _secureStorage.read(key: 'id_user');
    final token = await _secureStorage.read(key: 'jwt_token');

    if (idUser == null || token == null) {
      throw Exception('Usuario o token no encontrados');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/levels/$idLevel'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Level.fromJson(json);
    } else {
      throw Exception('Error al obtener datos del nivel');
    }
  }
}
