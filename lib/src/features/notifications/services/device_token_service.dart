import 'package:firebase_messaging/firebase_messaging.dart';

class DeviceTokenService {
  static Future<String?> getDeviceToken(
      {bool requestPermission = false}) async {
    try {
      FirebaseMessaging messaging = FirebaseMessaging.instance;

      // Solicita permisos solo si se indica
      if (requestPermission) {
        await messaging.requestPermission();
      }

      // Obtiene el token
      String? token = await messaging.getToken();
      return token;
    } catch (e) {
      print('Error al obtener el token del dispositivo: $e');
      return null;
    }
  }
}
