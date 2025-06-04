import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../../../utils/constants/api.dart';
import '../domain/profile_model.dart';

class ProfileService {
  final FlutterSecureStorage _secureStorage;

  ProfileService(this._secureStorage);

  Future<int> getProfileId() async {
    final idUserString = await _secureStorage.read(key: 'id_user');
    if (idUserString == null) {
      throw Exception('ID de usuario no encontrado en almacenamiento seguro');
    }
    return int.parse(idUserString);
  }

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

  Future<bool> updateProfile({
    String? email,
    String? phone,
    DateTime? birthday,
  }) async {
    try {
      final String? idUser = await _secureStorage.read(key: 'id_user');
      final String? jwtToken = await _secureStorage.read(key: 'jwt_token');

      if (idUser == null || jwtToken == null) {
        throw Exception('User or token not found');
      }

      final currentProfile = await getProfile();
      if (currentProfile == null) {
        throw Exception('No se pudo obtener el perfil actual');
      }

      final Map<String, dynamic> body = {
        'name': currentProfile.firstName,
        'lastName': currentProfile.lastName,
        'email': email ?? currentProfile.email,
        'phoneNumber': phone ?? currentProfile.phone,
        'birthDate': (birthday ?? currentProfile.birthday)
            ?.toIso8601String()
            .split('T')
            .first, // yyyy-MM-dd
      };

      final response = await http.patch(
        Uri.parse('$baseUrl/profiles/$idUser'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwtToken',
        },
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception(
          'Failed to update profile - Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error updating profile: $e');
    }
  }
}
