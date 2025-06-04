import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../../../common/utils/constants/call_session.dart';
import '../../../common/utils/constants/secure_storage.dart';
import '../../../routing/app_router.dart';

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
  RemoteMessage message,
  GlobalKey<NavigatorState> navigatorKey,
) async {
  final data = message.data;
  final type = data['type'];
  final token = data['token'];
  final channel = data['channel'];
  final idVideocall = data['idVideocall'];

  switch (type) {
    case 'videocall_start':
      if (token != null && channel != null) {
        final name = data['name'] ?? 'Desconocido';
        final lastname = data['lastname'] ?? '';
        final fullname = '$name $lastname'.trim();

        print('📞 Redirigiendo a VideoCallScreen');
        navigatorKey.currentState?.pushReplacementNamed(
          AppRouter.videoCallRoute,
          arguments: {
            'token': token,
            'channel': channel,
            'fullname': fullname,
            'idVideocall': idVideocall,
          },
        );
      }
      break;

    case 'videocall_end':
      final idVideocall = data['idVideocall'];
      final idVideocallInt = int.tryParse(idVideocall.toString());

      if (idVideocallInt == null) {
        debugPrint('⚠️ Notificación sin idVideocall');
        return;
      }

      final role = await SecureStorage.getRole();

      if (role == null) {
        debugPrint('⚠️ Rol no encontrado en almacenamiento seguro');
        return;
      }

      debugPrint(
          '🔁 Redirigiendo a ${role == 'requester' ? 'reviewRoute' : 'endVideocallRoute'} con id: $idVideocall');

      if (CallSession.isInVideoCallScreen) {
        debugPrint(
            '📴 Fin de videollamada detectado. Redirigiendo según rol...');

        final route = role == 'requester'
            ? AppRouter.reviewRoute
            : AppRouter.endVideocallRoute;

        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          route,
          (route) => false,
          arguments: idVideocallInt,
        );
      } else {
        debugPrint(
            '⚠️ No se está en pantalla de videollamada, no se redirige.');
      }
      break;

    default:
      print('🔔 Tipo de notificación desconocido: $type');
  }
}
