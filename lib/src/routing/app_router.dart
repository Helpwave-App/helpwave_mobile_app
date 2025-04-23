import 'package:flutter/material.dart';
import 'package:helpwave_mobile_app/src/features/auth/presentation/terms_and_conditions_screen.dart';

import '../features/auth/presentation/sign_in_screen.dart';
import '../features/auth/presentation/sign_up_screen.dart';
import '../features/auth/presentation/welcome_screen.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/videocall/presentation/videocall_screen.dart';

class AppRouter {
  static const String welcomeRoute = '/';
  static const String registerRoute = '/register';
  static const String termsRoute = '/terms-and-conditions';
  static const String loginRoute = '/login';
  static const String homeRoute = '/home';
  static const String videoCallRoute = '/videocall';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case welcomeRoute:
        return MaterialPageRoute(builder: (_) => const WelcomeScreen());

      case registerRoute:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());

      case termsRoute:
        return MaterialPageRoute(
            builder: (_) => const TermsAndConditionsScreen());

      case loginRoute:
        return MaterialPageRoute(builder: (_) => const SignInScreen());

      case homeRoute:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case videoCallRoute:
        final args = settings.arguments as Map<String, dynamic>;
        final token = args['token'] as String;
        final channelName = args['channelName'] as String;

        return MaterialPageRoute(
          builder: (_) => VideoCallScreen(
            token: token,
            channelName: channelName,
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Ruta no encontrada')),
          ),
        );
    }
  }
}
