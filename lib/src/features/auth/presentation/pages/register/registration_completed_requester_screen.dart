import 'package:flutter/material.dart';

import '../../../../../../localization/codegen_loader.g.dart';
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
      title: LocaleKeys.auth_registrationCompletedRequester_title,
      message: LocaleKeys.auth_registrationCompletedRequester_message,
      subtitle: LocaleKeys.auth_registrationCompletedRequester_subtitle,
      icon: Icons.volunteer_activism,
      userType: 'requester',
      username: username,
      password: password,
    );
  }
}
