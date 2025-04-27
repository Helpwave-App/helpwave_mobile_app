import 'package:flutter/material.dart';

import '../../widgets/registration_completed_widget.dart';

class RegistrationCompletedRequesterScreen extends StatelessWidget {
  const RegistrationCompletedRequesterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const RegistrationCompletedWidget(
      title: '¡Te has registrado con éxito!',
      message:
          'Bienvenido a HelpWave. Aquí encontrarás voluntarios listos para ayudarte con lo que necesites, cuando lo necesites.',
      subtitle: 'Gracias por confiar en nuestra comunidad solidaria.',
      icon: Icons.volunteer_activism,
      userType: 'requester',
    );
  }
}
