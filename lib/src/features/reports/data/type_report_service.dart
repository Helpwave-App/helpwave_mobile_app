import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../../../common/utils/constants/api.dart';
import '../domain/type_report_model.dart';

class TypeReportService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  Future<List<TypeReportModel>> fetchTypeReports() async {
    final token = await _secureStorage.read(key: 'jwt_token');

    if (token == null) {
      throw Exception('Tokenno encontrado');
    }

    final url = Uri.parse('$baseUrl/typeReports');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(
          'Error al obtener los tipos de reporte: ${response.body}');
    }
    final List<dynamic> data = json.decode(response.body);
    return data.map((json) => TypeReportModel.fromJson(json)).toList();
  }
}
