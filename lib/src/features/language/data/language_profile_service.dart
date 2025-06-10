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
    int? idProfile,
  }) async {
    int? profileId;

    if (idProfile != null) {
      profileId = idProfile;
      print('🔍 Usando idProfile del parámetro: $profileId');
    } else {
      final idUserStr = await _secureStorage.read(key: 'id_user');
      if (idUserStr != null) {
        profileId = int.tryParse(idUserStr);
        print('🔍 Obtenido idProfile del storage: $profileId');
      }
    }

    if (profileId == null) {
      throw Exception('idProfile no encontrado');
    }

    final url = Uri.parse('$baseUrl/languageProfiles');

    print('🔍 Enviando solicitud POST a: $url');
    print('🔍 Payload: {"idProfile": $profileId, "idLanguage": $idLanguage}');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "idProfile": profileId,
        "idLanguage": idLanguage,
      }),
    );

    print('🔍 Response Status: ${response.statusCode}');
    print('🔍 Response Body: ${response.body}');
    print('🔍 Response Headers: ${response.headers}');

    if (response.statusCode != 200) {
      String errorDetail = '';
      try {
        final errorData = jsonDecode(response.body);
        errorDetail = ' - Detalle: $errorData';
      } catch (e) {
        errorDetail = ' - Response: ${response.body}';
      }

      throw Exception(
          'Error al registrar idioma en el perfil (${response.statusCode})$errorDetail');
    }

    print('✅ Idioma agregado exitosamente al perfil $profileId');
  }

  Future<void> removeLanguageFromProfile(int idLanguageProfile) async {
    final token = await _secureStorage.read(key: 'jwt_token');

    if (token == null) {
      throw Exception('Token no encontrado');
    }

    final url = Uri.parse('$baseUrl/languageProfiles/$idLanguageProfile');

    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Error al eliminar el idioma del perfil (status ${response.statusCode}): ${response.body}',
      );
    }

    print(
        '✅ Idioma con id $idLanguageProfile eliminado correctamente del perfil');
  }
}
