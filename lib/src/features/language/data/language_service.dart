import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../common/utils/constants/api.dart';
import '../domain/language_model.dart';

class LanguageService {
  Future<List<LanguageModel>> fetchLanguages() async {
    final url = Uri.parse('$baseUrl/languages');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Error al cargar los idiomas (${response.statusCode})');
    }
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((json) => LanguageModel.fromJson(json)).toList();
  }
}
