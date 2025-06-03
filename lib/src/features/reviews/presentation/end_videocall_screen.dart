import 'package:flutter/material.dart';

class EndVideocallScreen extends StatelessWidget {
  final int idVideocall;

  const EndVideocallScreen({super.key, required this.idVideocall});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Videollamada finalizada')),
      body: Center(
        child: Text('ID de la videollamada: $idVideocall'),
      ),
    );
  }
}
