import 'package:flutter/material.dart';

import '../../../../../../localization/codegen_loader.g.dart';
import '../../../../../routing/app_router.dart';
import '../../widgets/sign_up_form.dart';

class SignUpRequesterScreen extends StatelessWidget {
  const SignUpRequesterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      body: const SignUpForm(
        titleKey: LocaleKeys.auth_signUpRequester_title,
        fields: [
          FormFieldData(
            labelKey: LocaleKeys.auth_signUpRequester_fields_name,
            translationKey: LocaleKeys.auth_signUpRequester_fields_name,
          ),
          FormFieldData(
            labelKey: LocaleKeys.auth_signUpRequester_fields_lastname,
            translationKey: LocaleKeys.auth_signUpRequester_fields_lastname,
          ),
          FormFieldData(
            labelKey: LocaleKeys.auth_signUpRequester_fields_phoneNumber,
            translationKey: LocaleKeys.auth_signUpRequester_fields_phoneNumber,
            keyboardType: TextInputType.phone,
          ),
          FormFieldData(
            labelKey: LocaleKeys.auth_signUpRequester_fields_username,
            translationKey: LocaleKeys.auth_signUpRequester_fields_username,
          ),
          FormFieldData(
            labelKey: LocaleKeys.auth_signUpRequester_fields_password,
            translationKey: LocaleKeys.auth_signUpRequester_fields_password,
            obscureText: true,
          ),
        ],
        nextRoute: AppRouter.registrationCompletedRequesterRoute,
        buttonTextKey: LocaleKeys.auth_signUpRequester_buttonText,
        userType: "requester",
      ),
    );
  }
}
