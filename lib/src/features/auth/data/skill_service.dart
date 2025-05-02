import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import '../../../utils/api.dart';
import '../domain/skill_model.dart';

class SkillService {
  Future<List<Skill>> fetchSkills() async {
    final url = Uri.parse('$baseUrl/skills');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      try {
        final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        print('Skills obtenidas: $data');
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
}
