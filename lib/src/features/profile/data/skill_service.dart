import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import '../../../utils/api.dart';
import '../domain/skill_model.dart';

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
    final url = Uri.parse('$baseUrl/skillProfiles/batch');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({
        'idProfile': idProfile,
        'skillIds': skillIds,
      }),
    );

    if (kDebugMode) {
      print('→ POST $url');
      print('← Status: ${response.statusCode}');
      print('← Body: ${response.body}');
    }

    return response.statusCode == 200 || response.statusCode == 201;
  }

  Future<List<Map<String, dynamic>>> getSkillsByProfileId() async {
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
        'Authorization': 'Bearer $jwtToken',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Error obteniendo skillProfiles');
    }

    final List<dynamic> skillProfiles =
        jsonDecode(utf8.decode(response.bodyBytes));

    final List<Map<String, dynamic>> detailedSkills = [];

    for (final sp in skillProfiles) {
      final idSkill = sp['idSkill'];
      final idSkillProfile = sp['idSkillProfile'];

      final skillRes = await http.get(
        Uri.parse('$baseUrl/skills/$idSkill'),
        headers: {
          'Authorization': 'Bearer $jwtToken',
        },
      );

      if (skillRes.statusCode == 200) {
        final skillData = jsonDecode(utf8.decode(skillRes.bodyBytes));
        detailedSkills.add({
          'idSkill': idSkill,
          'idSkillProfile': idSkillProfile,
          'skillDesc': skillData['skillDesc'],
        });
      }
    }

    return detailedSkills;
  }

  Future<bool> deleteSkillProfile(int idSkillProfile) async {
    final String? jwtToken = await _secureStorage.read(key: 'jwt_token');

    if (jwtToken == null) {
      throw Exception('Token not found');
    }

    final url = Uri.parse('$baseUrl/skillProfiles/$idSkillProfile');
    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwtToken',
      },
    );

    return response.statusCode == 200 || response.statusCode == 204;
  }
}
