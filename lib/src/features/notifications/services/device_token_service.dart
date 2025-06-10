import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../../common/utils/constants/api.dart';
import '../../../common/utils/constants/secure_storage.dart';

class DeviceTokenService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  static Future<String?> getDeviceToken(
      {bool requestPermission = false}) async {
    try {
      if (requestPermission) {
        final settings = await FirebaseMessaging.instance.requestPermission();
        print('🔐 Permiso notificaciones: ${settings.authorizationStatus}');
      }

      String? token = await FirebaseMessaging.instance.getToken();
      print('📱 Token actual del dispositivo: $token');
      return token;
    } catch (e) {
      print('❌ Error al obtener el token del dispositivo: $e');
      return null;
    }
  }

  Future<void> registerDeviceToken({
    required String newToken,
    String? oldToken,
  }) async {
    final idUser = await _secureStorage.read(key: 'id_user');
    final jwtToken = await _secureStorage.read(key: 'jwt_token');

    if (idUser == null || jwtToken == null) {
      print('❌ No hay idUser o jwtToken para registrar el token');
      return;
    }

    final url = Uri.parse('$baseUrl/devices/upsert');

    final body = {
      'idUser': int.parse(idUser),
      'newTokenDevice': newToken,
      if (oldToken != null) 'oldTokenDevice': oldToken,
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwtToken',
        },
        body: jsonEncode(body),
      );

      print('→ POST $url');
      print('→ Body: $body');
      print('← Status: ${response.statusCode}');
      print('← Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ Token FCM registrado/actualizado exitosamente');
      } else {
        print('❌ Error al registrar token FCM: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error en la petición de registro de token: $e');
      rethrow;
    }
  }

  Future<void> unregisterDeviceToken() async {
    final fcmToken = await getDeviceToken();
    final jwtToken = await _secureStorage.read(key: 'jwt_token');

    if (fcmToken == null || jwtToken == null) return;

    final url = Uri.parse('$baseUrl/devices/$fcmToken');

    try {
      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $jwtToken',
        },
      );

      if (response.statusCode == 200) {
        print('✅ Token eliminado del backend');
        await FirebaseMessaging.instance.deleteToken();
      } else {
        print('❌ Error al eliminar token del backend: ${response.body}');
      }
    } catch (e) {
      print('❌ Error eliminando token del dispositivo: $e');
    }
  }

  static void setupTokenRefreshListener() {
    FirebaseMessaging.instance.onTokenRefresh.listen((String token) async {
      print('🔄 FCM Token actualizado automáticamente: $token');

      final jwtToken = await SecureStorage.getToken();
      if (jwtToken != null && !JwtDecoder.isExpired(jwtToken)) {
        final service = DeviceTokenService();
        try {
          await service.registerDeviceToken(newToken: token);
          print('✅ Token automáticamente actualizado en backend');
        } catch (e) {
          print('❌ Error actualizando token automáticamente: $e');
        }
      } else {
        print('ℹ️ No hay usuario autenticado, token no registrado');
      }
    });
  }

  static Future<void> forceTokenRefresh() async {
    try {
      await FirebaseMessaging.instance.deleteToken();
      final newToken = await FirebaseMessaging.instance.getToken();
      print('🔄 Token forzosamente actualizado: $newToken');

      final jwtToken = await SecureStorage.getToken();
      if (jwtToken != null && !JwtDecoder.isExpired(jwtToken)) {
        final service = DeviceTokenService();
        if (newToken != null) {
          await service.registerDeviceToken(newToken: newToken);
        }
      }
    } catch (e) {
      print('❌ Error forzando actualización de token: $e');
    }
  }
}
