import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../../../common/utils/constants/api.dart';
import '../domain/review_model.dart';

class ReviewService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<void> submitReview(ReviewModel reviewModel) async {
    final token = await _secureStorage.read(key: 'jwt_token');

    if (token == null) {
      throw Exception('Token no encontrado');
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
