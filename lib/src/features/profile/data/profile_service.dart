import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../../../utils/api.dart';
import '../domain/profile_model.dart';

class ProfileService {
  final FlutterSecureStorage _secureStorage;

  ProfileService(this._secureStorage);

  Future<Profile?> getProfile() async {
    try {
      final String? idUser = await _secureStorage.read(key: 'id_user');
      final String? jwtToken = await _secureStorage.read(key: 'jwt_token');

      if (idUser == null || jwtToken == null) {
        throw Exception('User or token not found');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/profiles/$idUser'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwtToken',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Profile.fromJson(data);
      } else {
        throw Exception(
            'Failed to load profile - Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching profile: $e');
    }
  }
}
