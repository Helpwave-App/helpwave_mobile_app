import 'package:flutter/material.dart';

import '../../widgets/registration_completed.dart';

class RegistrationCompletedRequesterScreen extends StatelessWidget {
  const RegistrationCompletedRequesterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final username = args?['username'];
    final password = args?['password'];

    return RegistrationCompletedWidget(
      title: '¡Te has registrado con éxito!',
      message:
          'Bienvenido a HelpWave. Aquí encontrarás voluntarios listos para ayudarte con lo que necesites, cuando lo necesites.',
      subtitle: 'Gracias por confiar en nuestra comunidad solidaria.',
      icon: Icons.volunteer_activism,
      userType: 'requester',
      username: username,
      password: password,
    );
  }
}
