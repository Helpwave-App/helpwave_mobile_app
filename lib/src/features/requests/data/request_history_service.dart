import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../../../common/exceptions/api_exception.dart';
import '../../../common/utils/constants/api.dart';
import '../domain/request_model.dart';

class RequestHistoryService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<List<Request>> getRequestHistory() async {
    final token = await _secureStorage.read(key: 'jwt_token');
    final role = await _secureStorage.read(key: 'role');

    if (token == null || role == null) {
      throw ApiException(401, 'Credenciales no disponibles');
    }

    final url = Uri.parse('$baseUrl/requests/history');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw ApiException(response.statusCode, response.body);
    }

    final List<dynamic> data = jsonDecode(response.body);
    return data.map((json) => Request.fromJson(json)).toList();
  }
}
