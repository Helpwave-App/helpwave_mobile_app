import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

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
