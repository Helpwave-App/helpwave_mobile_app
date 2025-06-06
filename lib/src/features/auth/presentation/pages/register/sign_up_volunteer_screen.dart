import 'package:flutter/material.dart';

import '../../../../../routing/app_router.dart';
import '../../widgets/sign_up_form.dart';

class SignUpVolunteerScreen extends StatelessWidget {
  const SignUpVolunteerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      body: SignUpForm(
        titleKey: 'auth.signUpVolunteer.title',
        fields: const [
          FormFieldData(
            label: 'Nombre',
            translationKey: 'auth.signUpVolunteer.fields.name',
          ),
          FormFieldData(
            label: 'Apellido',
            translationKey: 'auth.signUpVolunteer.fields.lastname',
          ),
          FormFieldData(
            label: 'Correo electrónico',
            translationKey: 'auth.signUpVolunteer.fields.email',
            keyboardType: TextInputType.emailAddress,
          ),
          FormFieldData(
            label: 'Nombre de usuario',
            translationKey: 'auth.signUpVolunteer.fields.username',
          ),
          FormFieldData(
            label: 'Contraseña',
            translationKey: 'auth.signUpVolunteer.fields.password',
            obscureText: true,
          ),
        ],
        nextRoute: AppRouter.volunteerSkillsRoute,
        buttonTextKey: 'auth.signUpVolunteer.buttonText',
        userType: "volunteer",
      ),
    );
  }
}
