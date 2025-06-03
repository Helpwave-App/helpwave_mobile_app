import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../../../utils/constants/api.dart';
import '../domain/review_model.dart';

class ReviewService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<void> submitReview(ReviewModel reviewModel) async {
    final idUser = await _secureStorage.read(key: 'id_user');
    final token = await _secureStorage.read(key: 'jwt_token');

    if (token == null || idUser == null) {
      throw Exception('Token o idProfile no encontrados');
    }

    final url = Uri.parse('$baseUrl/comments');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(reviewModel.toJson()),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Error al registrar comentario: ${response.body}');
    }
  }
}
