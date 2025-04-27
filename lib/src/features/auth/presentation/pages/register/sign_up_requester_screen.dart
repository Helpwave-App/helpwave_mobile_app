import 'package:flutter/material.dart';

import '../../../../../routing/app_router.dart';
import '../../widgets/sign_up_form.dart';

class SignUpRequesterScreen extends StatelessWidget {
  const SignUpRequesterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      body: const SignUpForm(
        title: "Registro para recibir ayuda",
        fields: [
          FormFieldData(label: 'Nombre'),
          FormFieldData(label: 'Apellido'),
          FormFieldData(
              label: 'Número de teléfono', keyboardType: TextInputType.phone),
          FormFieldData(label: 'Contraseña', obscureText: true),
        ],
        nextRoute: AppRouter.registrationCompletedRequesterRoute,
        buttonText: 'Finalizar registro',
      ),
    );
  }
}
