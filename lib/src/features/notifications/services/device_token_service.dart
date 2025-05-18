import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../../utils/constants/api.dart';

class DeviceTokenService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  static Future<String?> getDeviceToken(
      {bool requestPermission = false}) async {
    try {
      FirebaseMessaging messaging = FirebaseMessaging.instance;

      if (requestPermission) {
        final settings = await messaging.requestPermission();
        print('🔐 Permiso notificaciones: ${settings.authorizationStatus}');
      }

      String? token = await messaging.getToken();
      return token;
    } catch (e) {
      print('Error al obtener el token del dispositivo: $e');
      return null;
    }
  }

  Future<void> registerDeviceToken({required String token}) async {
    final idUser = await _secureStorage.read(key: 'id_user');
    final jwtToken = await _secureStorage.read(key: 'jwt_token');

    print('📦 Token JWT leído para registrar dispositivo: $jwtToken');
    print('👤 User ID: $idUser');
    print('📱 Device token FCM: $token');

    if (idUser == null || jwtToken == null) {
      print('❌ Falta información para registrar token de dispositivo');
      return;
    }

    final url = Uri.parse('$baseUrl/devices');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwtToken',
      },
      body: jsonEncode({
        'idUser': idUser,
        'tokenDevice': token,
      }),
    );

    print('→ POST $url');
    print('← Status: ${response.statusCode}');
    print('← Body: ${response.body}');
  }
}
