// firebase_messaging_handler.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../../../../localization/codegen_loader.g.dart';
import '../../../common/utils/constants/call_session.dart';
import '../../../common/utils/constants/secure_storage.dart';
import '../../../routing/app_router.dart';
import '../../videocalls/data/videocall_service.dart';
import '../../videocalls/presentation/videocall_screen.dart';
import '../presentation/info_dialog.dart';
import '../presentation/request_dialog.dart';
import 'dialog_manager.dart';

bool _isProcessingNotification = false;

void setupFirebaseNotificationHandler(GlobalKey<NavigatorState> navigatorKey) {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('📩 Foreground Notification received: ${message.data}');
    _handleNotification(message, navigatorKey);
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('📲 Notification tapped: ${message.data}');
    _handleNotification(message, navigatorKey);
  });
}

void _handleNotification(
  RemoteMessage message,
  GlobalKey<NavigatorState> navigatorKey,
) async {
  final data = message.data;
  final type = data['type'];

  print('🔥 HANDLER UNIFICADO: Processing notification type: $type');
  print('🔥 Full data: $data');

  if (_isProcessingNotification) {
    print('❌ Ya se está procesando una notificación, ignorando...');
    return;
  }

  _isProcessingNotification = true;

  try {
    switch (type) {
      case 'help_request':
        await _handleHelpRequestNotification(data, navigatorKey);
        break;

      case 'videocall_start':
        await _handleVideocallStartNotification(data, navigatorKey);
        break;

      case 'videocall_end':
        await _handleVideocallEndNotification(data, navigatorKey);
        break;

      case 'request_cancelled':
        await _handleRequestCancelledNotification(data, navigatorKey);
        break;

      default:
        print('🔔 Tipo de notificación desconocido: $type');
    }
  } catch (e) {
    print('❌ Error procesando notificación: $e');
  } finally {
    _isProcessingNotification = false;
    print('🔥 Procesamiento de notificación completado');
  }
}

Future<void> _handleRequestCancelledNotification(
  Map<String, dynamic> data,
  GlobalKey<NavigatorState> navigatorKey,
) async {
  print('🚫 Procesando cancelación de solicitud...');

  final context = navigatorKey.currentContext;
  if (context == null) {
    print('❌ No context available for request cancelled');
    return;
  }

  // Close the request dialog if it's open
  if (DialogManager.isDialogShown) {
    Navigator.of(context).pop();
  }

  await showDialog(
    context: context,
    builder: (_) => InfoDialog(
      title: tr(LocaleKeys.notification_handler_requestCancelledTitle),
      message: tr(LocaleKeys.notification_handler_requestCancelledMessage),
    ),
  );
}

Future<void> _handleHelpRequestNotification(
  Map<String, dynamic> data,
  GlobalKey<NavigatorState> navigatorKey,
) async {
  print('🤝 Procesando solicitud de ayuda...');

  final idEmpairing = int.tryParse(data['idEmpairing'] ?? '');
  final skill =
      data['skill'] ?? tr(LocaleKeys.notification_handler_unknownSkill);
  final name = data['name'] ?? tr(LocaleKeys.notification_handler_unknownName);
  final lastname =
      data['lastname'] ?? tr(LocaleKeys.notification_handler_unknownLastName);
  final fullname = '$name $lastname';

  if (idEmpairing != null) {
    if (DialogManager.isDialogShown) {
      print('❌ Dialog already shown, ignoring help request');
      return;
    }

    final context = navigatorKey.currentContext;
    if (context == null) {
      print('❌ No context available for help request');
      return;
    }

    DialogManager.setDialogShown(true);
    print('✅ Dialog state set to: ${DialogManager.isDialogShown}');

    try {
      final result = await showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (_) => RequestDialog(
          skill: skill,
          fullname: fullname,
          onAccept: () {
            print('✅ Accept button pressed');
          },
          onReject: () {
            print('❌ Reject button pressed');
          },
        ),
      );

      print('🎯 Help request dialog closed with result: $result');

      if (result == 'accept') {
        await _processAcceptRequest(idEmpairing, fullname, navigatorKey);
      } else if (result == 'reject') {
        print('❌ Help request rejected by user');
      }
    } catch (e) {
      print('❌ Error showing help request dialog: $e');
    } finally {
      DialogManager.setDialogShown(false);
      print(
          '🔄 Help request dialog state reset to: ${DialogManager.isDialogShown}');
    }
  }
}

Future<void> _handleVideocallStartNotification(
  Map<String, dynamic> data,
  GlobalKey<NavigatorState> navigatorKey,
) async {
  print('📞 Procesando inicio de videollamada...');

  final token = data['token'];
  final channel = data['channel'];
  final idVideocall = data['idVideocall'];

  if (token != null && channel != null) {
    final name =
        data['name'] ?? tr(LocaleKeys.notification_handler_unknownName);
    final lastname =
        data['lastname'] ?? tr(LocaleKeys.notification_handler_unknownLastName);
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
}

Future<void> _handleVideocallEndNotification(
  Map<String, dynamic> data,
  GlobalKey<NavigatorState> navigatorKey,
) async {
  print('📴 Procesando fin de videollamada...');

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
    debugPrint('📴 Fin de videollamada detectado. Redirigiendo según rol...');

    final route = role == 'requester'
        ? AppRouter.reviewRoute
        : AppRouter.endVideocallRoute;

    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      route,
      (route) => false,
      arguments: idVideocallInt,
    );
  } else {
    debugPrint('⚠️ No se está en pantalla de videollamada, no se redirige.');
  }
}

Future<void> _processAcceptRequest(
  int idEmpairing,
  String fullname,
  GlobalKey<NavigatorState> navigatorKey,
) async {
  print('🤝 Processing accept request for idEmpairing: $idEmpairing');

  final service = VideocallService();

  try {
    final response = await service.acceptEmpairing(idEmpairing);
    print('✅ Accept request successful, navigating to video call');

    final context = navigatorKey.currentContext;
    if (context == null || !context.mounted) {
      print('❌ Context not available for navigation');
      return;
    }

    navigatorKey.currentState?.pushReplacement(
      MaterialPageRoute(
        builder: (_) => VideoCallScreen(
          channel: response.channel,
          token: response.token,
          fullname: fullname,
          idVideocall: response.idVideocall,
        ),
      ),
    );
  } catch (e) {
    print('❌ Error accepting request: $e');
    await _showErrorDialog(navigatorKey);
  }
}

Future<void> _showErrorDialog(GlobalKey<NavigatorState> navigatorKey) async {
  final context = navigatorKey.currentContext;
  if (context == null || !context.mounted) return;

  await showDialog(
    context: context,
    builder: (_) => InfoDialog(
      title: tr(LocaleKeys.notification_handler_alreadyAnsweredTitle),
      message: tr(LocaleKeys.notification_handler_alreadyAnsweredMessage),
    ),
  );
}
