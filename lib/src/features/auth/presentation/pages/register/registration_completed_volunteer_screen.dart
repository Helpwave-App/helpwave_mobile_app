import 'package:flutter/material.dart';

import '../../../../../../localization/codegen_loader.g.dart';
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
      title: LocaleKeys.auth_registrationCompletedVolunteer_title,
      message: LocaleKeys.auth_registrationCompletedVolunteer_message,
      subtitle: LocaleKeys.auth_registrationCompletedVolunteer_subtitle,
      icon: Icons.volunteer_activism,
      userType: 'volunteer',
      username: username,
      password: password,
    );
  }
}
