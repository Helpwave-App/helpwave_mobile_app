import 'package:flutter/material.dart';

import '../widgets/home_widget.dart';

class HomeRequesterScreen extends StatelessWidget {
  const HomeRequesterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeWidget(
      greeting: '¡Hola!',
      subtitle: '¿Listo para recibir ayuda hoy?',
      buttonText: 'Solicitar\nasistencia',
    );
  }
}
