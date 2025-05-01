import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../constants/api.dart';
import '../domain/availability_model.dart';

class AvailabilityService {
  static Future<bool> saveAvailability(AvailabilityPayload payload) async {
    final url = Uri.parse('$baseUrl/availabilities/batch');

    print('Payload enviado: ${jsonEncode(payload)}');

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
      print('Código de estado: ${response.statusCode}');
      print('Cuerpo de respuesta: ${response.body}');
      return false;
    }
  }
}
