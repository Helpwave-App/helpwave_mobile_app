import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../localization/codegen_loader.g.dart';

Future<bool> checkAndHandlePermanentDenial({
  required BuildContext context,
  required Permission permission,
  required String permissionName,
}) async {
  final status = await permission.status;

  if (status.isPermanentlyDenied) {
    if (!context.mounted) return true;
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(LocaleKeys.auth_permissions_dialog_title.tr()),
        content: Text(
          LocaleKeys.auth_permissions_dialog_content.tr(args: [permissionName]),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(LocaleKeys.auth_permissions_dialog_cancel.tr()),
          ),
          TextButton(
            onPressed: () {
              openAppSettings();
              Navigator.pop(context);
            },
            child: Text(LocaleKeys.auth_permissions_dialog_openSettings.tr()),
          ),
        ],
      ),
    );
    return true;
  }

  return false;
}