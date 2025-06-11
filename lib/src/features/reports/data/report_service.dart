import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../../../common/utils/constants/api.dart';
import '../domain/report_model.dart';

class ReportService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<void> createReport(ReportModel report) async {
    final idUserStr = await _secureStorage.read(key: 'id_user');
    final token = await _secureStorage.read(key: 'jwt_token');

    if (token == null) {
      throw Exception('Token no encontrado');
    }

    final idUser = int.parse(idUserStr!);
    final url = Uri.parse('$baseUrl/reports');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(report.toJson(idUser)),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(
        'Error al registrar el reporte: ${response.statusCode} - ${response.body}',
      );
    }
  }
}
