import 'package:flutter/material.dart';

import '../../widgets/registration_completed.dart';

class RegistrationCompletedVolunteerScreen extends StatelessWidget {
  const RegistrationCompletedVolunteerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final username = args?['username'];
    final password = args?['password'];

    return RegistrationCompletedWidget(
      title: '¡Gracias por registrarte como voluntario!',
      message:
          'Ahora formas parte de HelpWave, donde podrás brindar apoyo a personas que lo necesitan de forma remota.',
      subtitle: 'Tu tiempo y ayuda pueden marcar una gran diferencia.',
      icon: Icons.volunteer_activism,
      userType: 'volunteer',
      username: username,
      password: password,
    );
  }
}
