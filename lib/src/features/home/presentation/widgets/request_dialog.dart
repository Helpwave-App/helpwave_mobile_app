import 'package:flutter/material.dart';
import '../../../../utils/permissions_helper.dart';

typedef OnAccept = Future<void> Function();
typedef OnReject = void Function();

class RequestDialog extends StatelessWidget {
  final String skill;
  final OnAccept onAccept;
  final OnReject onReject;

  const RequestDialog({
    super.key,
    required this.skill,
    required this.onAccept,
    required this.onReject,
  });

  Future<void> _handleAccept(BuildContext context) async {
    final hasPermissions = await checkAndRequestEssentialPermissions(context);

    if (!hasPermissions) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Por favor, concede los permisos necesarios para aceptar la solicitud.',
            ),
          ),
        );
      }
      return;
    }

    if (context.mounted) {
      Navigator.of(context).pop();
    }

    await onAccept();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Nueva solicitud de ayuda"),
      content: Text("Habilidad solicitada: $skill"),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onReject();
          },
          child: const Text("Rechazar"),
        ),
        ElevatedButton(
          onPressed: () => _handleAccept(context),
          child: const Text("Aceptar"),
        ),
      ],
    );
  }
}
