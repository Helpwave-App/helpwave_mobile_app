import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../../../utils/api.dart';
import '../domain/availability_model.dart';
import '../domain/availability_payload_model.dart';

class AvailabilityService {
  final _secureStorage = const FlutterSecureStorage();

  static Future<bool> saveAvailability(AvailabilityPayload payload) async {
    final url = Uri.parse('$baseUrl/availabilities/batch');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(payload.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<Availability>> getAvailabilitiesByUser() async {
    final idUser = await _secureStorage.read(key: 'id_user');
    final token = await _secureStorage.read(key: 'jwt_token');

    if (idUser == null || token == null) {
      throw Exception('Usuario o token no encontrados');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/availabilities/user/$idUser'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Error al obtener disponibilidad');
    }

    final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
    return data.map((e) => Availability.fromJson(e)).toList();
  }

  Future<bool> deleteAvailability(String idAvailability) async {
    final token = await _secureStorage.read(key: 'jwt_token');

    if (token == null) {
      throw Exception('Token no encontrados');
    }

    final response = await http.delete(
      Uri.parse('$baseUrl/availabilities/$idAvailability'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    return response.statusCode == 200;
  }
}
