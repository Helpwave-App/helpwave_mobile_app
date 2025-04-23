import 'package:flutter/material.dart';

import '../widgets/home_widget.dart';

class HomeVolunteerScreen extends StatelessWidget {
  const HomeVolunteerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeWidget(
      greeting: '¡Hola!',
      subtitle: '¿Listo para brindar ayuda hoy?',
      buttonText: 'Aceptar\nsolicitud',
    );
  }
}
