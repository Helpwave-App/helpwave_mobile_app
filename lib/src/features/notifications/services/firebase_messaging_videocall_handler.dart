import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../../../routing/app_router.dart';
import '../../../utils/constants/call_session.dart';

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
  final type = data['type'];
  final token = data['token'];
  final channel = data['channel'];

  switch (type) {
    case 'videocall_start':
      if (token != null && channel != null) {
        final name = data['name'] ?? 'Desconocido';
        final lastname = data['lastname'] ?? '';
        final fullname = '$name $lastname'.trim();

        print('📞 Redirigiendo a VideoCallScreen');
        navigatorKey.currentState?.pushNamed(
          AppRouter.videoCallRoute,
          arguments: {
            'token': token,
            'channel': channel,
            'fullname': fullname,
          },
        );
      }
      break;

    case 'videocall_end':
      if (CallSession.isInVideoCallScreen) {
        debugPrint('📴 Notificación: Fin de videollamada detectado');
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          AppRouter.loadingRoute,
          (Route<dynamic> route) => false,
        );
      } else {
        debugPrint(
            '⚠️ No se está en la pantalla de videollamada, no se navega.');
      }
      break;

    default:
      print('🔔 Tipo de notificación desconocido: $type');
  }
}
