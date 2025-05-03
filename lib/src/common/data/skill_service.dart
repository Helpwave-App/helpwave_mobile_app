import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import '../../utils/api.dart';
import '../../features/auth/domain/skill_model.dart';

class SkillService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  Future<List<Skill>> fetchSkills() async {
    final url = Uri.parse('$baseUrl/skills');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      try {
        final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        return data.map((json) => Skill.fromJson(json)).toList();
      } catch (e) {
        throw Exception('Error al parsear habilidades: $e');
      }
    } else {
      throw Exception('Error al obtener habilidades: ${response.statusCode}');
    }
  }

  Future<bool> submitVolunteerSkills({
    required int idProfile,
    required List<int> skillIds,
  }) async {
    if (kDebugMode) {
      print('Enviando habilidades al backend con idProfile: $idProfile');
      print('Habilidades seleccionadas: $skillIds');
    }
    final url = Uri.parse('$baseUrl/skillProfiles/batch');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'idProfile': idProfile,
        'skillIds': skillIds,
      }),
    );

    return response.statusCode == 200 || response.statusCode == 201;
  }

  Future<bool> updateVolunteerSkills(
      String username, List<String> skills) async {
    final url = Uri.parse('$baseUrl/user/skills');
    final payload = {
      'username': username,
      'skills': skills,
    };

    if (kDebugMode) {
      print('→ PUT $url');
      print('Payload: ${jsonEncode(payload)}');
    }

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    if (kDebugMode) {
      print('← Status: ${response.statusCode}');
      print('← Response: ${response.body}');
    }

    return response.statusCode == 200;
  }

  Future<List<String>> getSkillsByProfileId() async {
    print('📥 Iniciando obtención de habilidades para el perfil');

    final String? idUserString = await _secureStorage.read(key: 'id_user');
    final String? jwtToken = await _secureStorage.read(key: 'jwt_token');

    if (idUserString == null || jwtToken == null) {
      throw Exception('User ID or token not found');
    }

    final idUser = int.tryParse(idUserString);
    if (idUser == null) {
      throw Exception('Invalid user ID');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/skillProfiles/user/$idUser'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwtToken',
      },
    );

    print('🔄 Respuesta de skillProfiles: ${response.statusCode}');
    print('📦 Body skillProfiles: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Error obteniendo skillProfiles');
    }

    final List<dynamic> skillProfiles =
        jsonDecode(utf8.decode(response.bodyBytes));

    final List<String> skillNames = [];

    for (final sp in skillProfiles) {
      final idSkill = sp['idSkill'];
      print('➡️ Consultando skill con ID: $idSkill');

      final skillRes = await http.get(
        Uri.parse('$baseUrl/skills/$idSkill'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwtToken',
        },
      );

      print('🔄 Respuesta de skill $idSkill: ${skillRes.statusCode}');
      print('📦 Body skill $idSkill: ${skillRes.body}');

      if (skillRes.statusCode == 200) {
        final skillData = jsonDecode(utf8.decode(skillRes.bodyBytes));
        final skillDesc = skillData['skillDesc'];
        skillNames.add(skillDesc);
        print('✅ Skill obtenida: $skillDesc');
      } else {
        print('⚠️ Error al obtener skill con ID $idSkill');
      }
    }

    print('🎯 Lista final de skills: $skillNames');
    return skillNames;
  }
}
