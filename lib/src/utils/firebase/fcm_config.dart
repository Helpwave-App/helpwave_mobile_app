import 'package:firebase_messaging/firebase_messaging.dart';

class FcmConfig {
  static Future<void> initializeFCM({bool requestPermission = false}) async {
    final fcm = FirebaseMessaging.instance;

    if (requestPermission) {
      await fcm.requestPermission();
    }

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
