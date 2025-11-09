import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    // Configurar las notificaciones
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: DarwinInitializationSettings(),
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Crear los canales de notificación
    await _createNotificationChannels();
  }

  static Future<void> _createNotificationChannels() async {
    // Canal para videollamadas
    const AndroidNotificationChannel videoCallChannel =
        AndroidNotificationChannel(
      'helpwave_videocall_channel', // ID del canal
      'Videollamadas', // Nombre del canal
      description:
          'Notificaciones de videollamadas y solicitudes de ayuda en tiempo real.',
      importance: Importance.high, // Alta prioridad
      enableVibration: true,
      playSound: true,
    );

    // Canal para alertas de ayuda
    const AndroidNotificationChannel helpAlertChannel =
        AndroidNotificationChannel(
      'helpwave_alerts_channel', // ID del canal
      'Alertas de Ayuda', // Nombre del canal
      description: 'Notificaciones de solicitudes y actualizaciones de ayuda.',
      importance: Importance.high, // Alta prioridad
      enableVibration: true,
      playSound: true,
    );

    // Registra los canales con Firebase
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(videoCallChannel);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(helpAlertChannel);
  }

  static Future<void> showNotification(
      String title, String body, String channelId) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      channelId,
      'Channel Name',
      channelDescription: 'Channel Description',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
    );

    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0, // ID de la notificación
      title,
      body,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }
}
