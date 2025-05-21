import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../../help_response/presentation/videocall_screen.dart';

void setupVideocallNotificationHandler(GlobalKey<NavigatorState> navigatorKey) {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('📩 Foreground Notification received: ${message.data}');
    _handleVideocallNotification(message, navigatorKey);
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('📲 Notification tapped: ${message.data}');
    _handleVideocallNotification(message, navigatorKey);
  });
}

void _handleVideocallNotification(
    RemoteMessage message, GlobalKey<NavigatorState> navigatorKey) {
  final data = message.data;
  print('📩 Notificación recibida (onMessage/onOpenedApp): ${data}');

  if (data['type'] == 'videocall_start') {
    final token = data['token'];
    final channel = data['channel'];

    if (token != null && channel != null) {
      print('📞 Redirigiendo a VideoCallScreen');

      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => VideoCallScreen(token: token, channel: channel),
        ),
      );
    }
  }
}
