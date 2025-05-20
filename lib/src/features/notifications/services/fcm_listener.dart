import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../../help_response/data/videocall_service.dart';
import '../../help_response/presentation/videocall_screen.dart';
import '../../home/presentation/pages/home_volunteer_screen.dart';
import '../../home/presentation/widgets/request_dialog.dart';

void setupFCMListener(GlobalKey<NavigatorState> navigatorKey) {
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    final data = message.data;

    if (data['type'] == 'help_request') {
      final idEmpairing = int.parse(data['idEmpairing']);
      final skill = data['skill'] ?? 'Desconocida';
      final time = data['time'] ?? 'Ahora';

      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => HomeVolunteerScreen(
            onDialogRequested: () async {
              final context = navigatorKey.currentContext!;
              showDialog(
                context: context,
                builder: (_) => RequestDialog(
                  skill: skill,
                  time: time,
                  onAccept: () async {
                    final service = VideocallService();
                    try {
                      final response =
                          await service.acceptEmpairing(idEmpairing);

                      // Ir a la pantalla de videollamada
                      navigatorKey.currentState?.pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => VideoCallScreen(
                            channel: response.channel,
                            token: response.token,
                          ),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $e')),
                      );
                    }
                  },
                  onReject: () {
                    // Puedes hacer algo en rechazo si deseas.
                  },
                ),
              );
            },
          ),
        ),
      );
    }
  });
}
