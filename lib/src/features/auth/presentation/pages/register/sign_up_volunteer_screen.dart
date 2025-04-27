import 'package:flutter/material.dart';

import '../../../../../routing/app_router.dart';
import '../../widgets/sign_up_form.dart';

class SignUpVolunteerScreen extends StatelessWidget {
  const SignUpVolunteerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      body: const SignUpForm(
        title: "Registro como Voluntario",
        fields: [
          FormFieldData(label: 'Nombre'),
          FormFieldData(label: 'Apellido'),
          FormFieldData(
              label: 'Correo electrónico',
              keyboardType: TextInputType.emailAddress),
          FormFieldData(label: 'Contraseña', obscureText: true),
        ],
        nextRoute: AppRouter.volunteerSkillsRoute,
        buttonText: 'Siguiente',
      ),
    );
  }
}
