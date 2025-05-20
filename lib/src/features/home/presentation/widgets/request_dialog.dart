import 'package:flutter/material.dart';

typedef OnAccept = Future<void> Function();
typedef OnReject = void Function();

class RequestDialog extends StatelessWidget {
  final String skill;
  final String time;
  final OnAccept onAccept;
  final OnReject onReject;

  const RequestDialog({
    super.key,
    required this.skill,
    required this.time,
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
          Text("Habilidad solicitada: $skill"),
          const SizedBox(height: 8),
          Text("Hora: $time"),
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
          onPressed: () async {
            Navigator.of(context).pop();
            await onAccept();
          },
          child: const Text("Aceptar"),
        ),
      ],
    );
  }
}
