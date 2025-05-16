import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../../utils/constants/api.dart';
import '../../../utils/constants/secure_storage.dart';

class DeviceTokenService {
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

  static Future<void> registerDeviceToken({required String token}) async {
    try {
      final userId = await SecureStorage.getIdUser();
      if (userId == null) {
        print('❌ No se encontró ID del usuario para registrar el token');
        return;
      }

      final url = Uri.parse('$baseUrl/devices');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await SecureStorage.getToken()}',
        },
        body: jsonEncode({
          'idUser': userId,
          'tokenDevice': token,
        }),
      );

      print('→ POST $url');
      print('← Status: ${response.statusCode}');
      print('← Body: ${response.body}');
    } catch (e) {
      print('❌ Error al registrar el token en el backend: $e');
    }
  }
}
