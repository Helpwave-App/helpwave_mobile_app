import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../../videocall/presentation/videocall_screen.dart';

void setupFCMListener(GlobalKey<NavigatorState> navigatorKey) {
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    final data = message.data;
    if (data['type'] == 'videocall_started') {
      final channel = data['channel'];
      final token = data['token'];

      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => VideoCallScreen(channel: channel, token: token),
        ),
      );
    }
  });
}
