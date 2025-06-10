import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../../../common/utils/constants/api.dart';
import '../domain/language_profile_model.dart';

class LanguageProfileService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<List<LanguageProfileModel>> getLanguagesByUserId() async {
    final idUser = await _secureStorage.read(key: 'id_user');
    final token = await _secureStorage.read(key: 'jwt_token');

    if (token == null || idUser == null) {
      throw Exception('Token o idProfile no encontrados');
    }

    final url = Uri.parse('$baseUrl/languageProfiles/user/$idUser');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
          'Error al obtener idiomas del usuario (${response.statusCode})');
    }

    final List<dynamic> data = jsonDecode(response.body);
    return data.map((json) => LanguageProfileModel.fromJson(json)).toList();
  }

  Future<void> addLanguageToProfile({
    required int idLanguage,
  }) async {
    final idUser = await _secureStorage.read(key: 'id_user');
    final token = await _secureStorage.read(key: 'jwt_token');

    if (token == null || idUser == null) {
      throw Exception('Token o idProfile no encontrados');
    }

    final url = Uri.parse('$baseUrl/languageProfiles');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "idProfile": idUser,
        "idLanguage": idLanguage,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception(
          'Error al registrar idioma en el perfil (${response.statusCode})');
    }
  }
}
