import 'package:flutter/material.dart';

import '../../../../../../localization/codegen_loader.g.dart';
import '../../../../../routing/app_router.dart';
import '../../widgets/sign_up_form.dart';

class SignUpVolunteerScreen extends StatelessWidget {
  const SignUpVolunteerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      body: SignUpForm(
        titleKey: LocaleKeys.auth_signUpVolunteer_title,
        fields: const [
          FormFieldData(
            labelKey: LocaleKeys.auth_signUpVolunteer_fields_name,
            translationKey: LocaleKeys.auth_signUpVolunteer_fields_name,
          ),
          FormFieldData(
            labelKey: LocaleKeys.auth_signUpVolunteer_fields_lastname,
            translationKey: LocaleKeys.auth_signUpVolunteer_fields_lastname,
          ),
          FormFieldData(
            labelKey: LocaleKeys.auth_signUpVolunteer_fields_email,
            translationKey: LocaleKeys.auth_signUpVolunteer_fields_email,
            keyboardType: TextInputType.emailAddress,
          ),
          FormFieldData(
            labelKey: LocaleKeys.auth_signUpVolunteer_fields_username,
            translationKey: LocaleKeys.auth_signUpVolunteer_fields_username,
          ),
          FormFieldData(
            labelKey: LocaleKeys.auth_signUpVolunteer_fields_password,
            translationKey: LocaleKeys.auth_signUpVolunteer_fields_password,
            obscureText: true,
          ),
        ],
        nextRoute: AppRouter.volunteerSkillsRoute,
        buttonTextKey: LocaleKeys.auth_signUpVolunteer_buttonText,
        userType: "volunteer",
      ),
    );
  }
}
