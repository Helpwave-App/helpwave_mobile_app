// firebase_messaging_help_request_handler.dart
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../../help_response/data/videocall_service.dart';
import '../../help_response/presentation/videocall_screen.dart';
import '../../home/presentation/pages/home_volunteer_screen.dart';
import '../../home/presentation/widgets/request_dialog.dart';

void setupHelpRequestNotificationHandler(
    GlobalKey<NavigatorState> navigatorKey) {
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    final data = message.data;

    if (data['type'] == 'help_request') {
      final idEmpairing = int.tryParse(data['idEmpairing'] ?? '');
      final skill = data['skill'] ?? 'Desconocida';

      if (idEmpairing != null) {
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (_) => HomeVolunteerScreen(
              onDialogRequested: () async {
                final context = navigatorKey.currentContext!;
                showDialog(
                  context: context,
                  builder: (_) => RequestDialog(
                    skill: skill,
                    onAccept: () async {
                      final service = VideocallService();
                      try {
                        final response =
                            await service.acceptEmpairing(idEmpairing);
                        Navigator.of(context).pop();

                        navigatorKey.currentState?.pushReplacement(
                          MaterialPageRoute(
                            builder: (_) => VideoCallScreen(
                              channel: response.channel,
                              token: response.token,
                            ),
                          ),
                        );
                      } catch (e) {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: $e')),
                        );
                      }
                    },
                    onReject: () {
                      // TODO: Implementar lógica para rechazo si es necesario
                    },
                  ),
                );
              },
            ),
          ),
        );
      }
    }
  });
}
