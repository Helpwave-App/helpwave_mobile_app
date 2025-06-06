import 'package:flutter/material.dart';

import '../../../../../routing/app_router.dart';
import '../../widgets/sign_up_form.dart';

class SignUpRequesterScreen extends StatelessWidget {
  const SignUpRequesterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      body: SignUpForm(
        titleKey: 'auth.signUpRequester.title',
        fields: const [
          FormFieldData(
            label: 'Nombre',
            translationKey: 'auth.signUpRequester.fields.name',
          ),
          FormFieldData(
            label: 'Apellido',
            translationKey: 'auth.signUpRequester.fields.lastname',
          ),
          FormFieldData(
            label: 'Número de teléfono',
            translationKey: 'auth.signUpRequester.fields.phoneNumber',
            keyboardType: TextInputType.phone,
          ),
          FormFieldData(
            label: 'Nombre de usuario',
            translationKey: 'auth.signUpRequester.fields.username',
          ),
          FormFieldData(
            label: 'Contraseña',
            translationKey: 'auth.signUpRequester.fields.password',
            obscureText: true,
          ),
        ],
        nextRoute: AppRouter.registrationCompletedRequesterRoute,
        buttonTextKey: 'auth.signUpRequester.buttonText',
        userType: "requester",
      ),
    );
  }
}
