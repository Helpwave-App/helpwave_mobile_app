import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

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
      title: tr('auth.registrationCompletedVolunteer.title'),
      message: tr('auth.registrationCompletedVolunteer.message'),
      subtitle: tr('auth.registrationCompletedVolunteer.subtitle'),
      icon: Icons.volunteer_activism,
      userType: 'volunteer',
      username: username,
      password: password,
    );
  }
}
