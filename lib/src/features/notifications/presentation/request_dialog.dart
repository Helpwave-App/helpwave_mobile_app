import 'package:flutter/material.dart';

typedef OnAccept = Future<void> Function();
typedef OnReject = void Function();

class RequestDialog extends StatelessWidget {
  final String skill;
  final String fullname;
  final OnAccept onAccept;
  final OnReject onReject;

  const RequestDialog({
    super.key,
    required this.skill,
    required this.fullname,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Nueva solicitud de ayuda"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Nombre del solicitante: $fullname"),
          const SizedBox(height: 8),
          Text("Habilidad solicitada: $skill"),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onReject();
          },
          child: const Text("Rechazar"),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            onAccept();
          },
          child: const Text("Aceptar"),
        ),
      ],
    );
  }
}
