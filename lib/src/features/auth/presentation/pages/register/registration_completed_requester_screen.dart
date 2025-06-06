import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

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
      title: tr('auth.registrationCompletedRequester.title'),
      message: tr('auth.registrationCompletedRequester.message'),
      subtitle: tr('auth.registrationCompletedRequester.subtitle'),
      icon: Icons.volunteer_activism,
      userType: 'requester',
      username: username,
      password: password,
    );
  }
}
