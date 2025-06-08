import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../localization/codegen_loader.g.dart';
import '../../videocalls/data/videocall_service.dart';
import '../../videocalls/presentation/videocall_screen.dart';
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
      final skill =
          data['skill'] ?? tr(LocaleKeys.notification_handler_unknownSkill);
      final name =
          data['name'] ?? tr(LocaleKeys.notification_handler_unknownName);
      final lastname = data['lastname'] ??
          tr(LocaleKeys.notification_handler_unknownLastName);
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
                            builder: (_) => InfoDialog(
                              title: tr(LocaleKeys
                                  .notification_handler_alreadyAnsweredTitle),
                              message: tr(LocaleKeys
                                  .notification_handler_alreadyAnsweredMessage),
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
