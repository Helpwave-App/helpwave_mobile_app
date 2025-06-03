import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../../help_response/data/videocall_service.dart';
import '../../help_response/presentation/videocall_screen.dart';
import '../../home/presentation/pages/home_volunteer_screen.dart';
import '../presentation/request_dialog.dart';
import '../presentation/info_dialog.dart';
import 'dialog_manager.dart';

void setupHelpRequestNotificationHandler(
    GlobalKey<NavigatorState> navigatorKey) {
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    final data = message.data;

    if (data['type'] == 'help_request') {
      final idEmpairing = int.tryParse(data['idEmpairing'] ?? '');
      final skill = data['skill'] ?? 'Desconocida';
      final name = data['name'] ?? 'Desconocido';
      final lastname = data['lastname'] ?? 'Desconocido';
      final fullname = '$name $lastname';

      if (idEmpairing != null) {
        if (DialogManager.isDialogShown) return;

        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (_) => HomeVolunteerScreen(
              onDialogRequested: () async {
                final context = navigatorKey.currentContext!;
                DialogManager.setDialogShown(true);

                await showDialog(
                  context: context,
                  builder: (_) => RequestDialog(
                    skill: skill,
                    fullname: fullname,
                    onAccept: () async {
                      final context = navigatorKey.currentContext;
                      if (context == null) return;

                      final service = VideocallService();
                      try {
                        final response =
                            await service.acceptEmpairing(idEmpairing);

                        if (!context.mounted) return;

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
                        if (context.mounted) {
                          showDialog(
                            context: context,
                            builder: (_) => const InfoDialog(
                              title: "¡Gracias por tu disposición!",
                              message:
                                  "Otro voluntario ya respondió a esta solicitud. Apreciamos mucho tu intención de ayudar 😊.",
                            ),
                          );
                        }
                      }
                    },
                    onReject: () {
                      // Lógica opcional
                    },
                  ),
                );

                DialogManager.setDialogShown(false);
              },
            ),
          ),
        );
      }
    }
  });
}
