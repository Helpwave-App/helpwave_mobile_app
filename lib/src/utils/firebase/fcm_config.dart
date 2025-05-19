import 'package:firebase_messaging/firebase_messaging.dart';

import '../../features/notifications/services/device_token_service.dart';

class FcmConfig {
  static Future<void> initializeFCM() async {
    final fcm = FirebaseMessaging.instance;
    final deviceTokenService = DeviceTokenService();

    await fcm.requestPermission();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("🔔 Notificación en foreground:");
      print("Título: ${message.notification?.title}");
      print("Cuerpo: ${message.notification?.body}");
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("🚀 Usuario abrió la notificación:");
      print("Título: ${message.notification?.title}");
      print("Cuerpo: ${message.notification?.body}");
    });
  }
}
