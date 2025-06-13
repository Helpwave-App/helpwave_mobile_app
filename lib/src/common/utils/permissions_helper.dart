import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

Future<bool> checkAndHandlePermanentDenial({
  required BuildContext context,
  required Permission permission,
  required String permissionName,
}) async {
  final status = await permission.status;

  if (status.isPermanentlyDenied) {
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Permiso requerido'),
        content: Text(
          'El permiso para $permissionName ha sido denegado permanentemente. '
          'Por favor, habilítalo manualmente desde la configuración de la app.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              openAppSettings();
              Navigator.pop(context);
            },
            child: const Text('Abrir configuración'),
          ),
        ],
      ),
    );
    return true;
  }

  return false;
}

Future<bool> checkAndRequestEssentialPermissions(BuildContext context) async {
  try {
    final permissions = <Permission, String>{
      Permission.camera: 'la cámara',
      Permission.microphone: 'el micrófono',
    };

    for (final entry in permissions.entries) {
      final permission = entry.key;
      final name = entry.value;

      if (await checkAndHandlePermanentDenial(
        context: context,
        permission: permission,
        permissionName: name,
      )) return false;

      if (!await permission.isGranted) {
        final result = await permission.request();
        if (!result.isGranted) return false;
      }
    }

    if (Platform.isAndroid || Platform.isIOS) {
      final notificationPermission = Permission.notification;
      final notificationName = 'las notificaciones';

      if (await checkAndHandlePermanentDenial(
        context: context,
        permission: notificationPermission,
        permissionName: notificationName,
      )) return false;

      if (!await notificationPermission.isGranted) {
        final result = await notificationPermission.request();
        if (!result.isGranted) return false;
      }
    }

    return true;
  } catch (e) {
    debugPrint('Error verificando permisos: $e');
    return false;
  }
}
