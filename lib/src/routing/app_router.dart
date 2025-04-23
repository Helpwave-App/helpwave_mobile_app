import 'package:flutter/material.dart';
import 'package:helpwave_mobile_app/src/features/auth/presentation/register/registration_completed_screen.dart';
import 'package:helpwave_mobile_app/src/features/auth/presentation/register/requester_interests_screen.dart';
import 'package:helpwave_mobile_app/src/features/auth/presentation/register/terms_and_conditions_screen.dart';
import 'package:helpwave_mobile_app/src/features/auth/presentation/register/user_type_selection_screen.dart';

import '../features/auth/presentation/login/sign_in_screen.dart';
import '../features/auth/presentation/register/sign_up_screen.dart';
import '../features/auth/presentation/welcome_screen.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/videocall/presentation/videocall_screen.dart';

class AppRouter {
  static const String welcomeRoute = '/';
  static const String registerRoute = '/register';
  static const String termsRoute = '/terms-and-conditions';
  static const String userTypeRoute = '/user-type';
  static const String requesterInterestsRoute = '/requester-interests';
  static const String volunteerSkillsRoute = '/volunteer-skills';
  static const String registrationCompletedRoute = '/registration-completed';
  static const String loginRoute = '/login';
  static const String homeRoute = '/home';
  static const String videoCallRoute = '/videocall';

  static Widget? getPageFromRoute(String routeName,
      {Map<String, dynamic>? args}) {
    switch (routeName) {
      case welcomeRoute:
        return const WelcomeScreen();

      case registerRoute:
        return const SignUpScreen();

      case termsRoute:
        return const TermsAndConditionsScreen();

      case userTypeRoute:
        return const UserTypeSelectionScreen();

      case requesterInterestsRoute:
        return const RequesterInterestsScreen();

      case registrationCompletedRoute:
        return const RegistrationCompletedScreen();

      case loginRoute:
        return const SignInScreen();

      case homeRoute:
        return const HomeScreen();

      case videoCallRoute:
        if (args == null ||
            !args.containsKey('token') ||
            !args.containsKey('channelName')) {
          return const Scaffold(body: Center(child: Text('Faltan argumentos')));
        }
        return VideoCallScreen(
          token: args['token'],
          channelName: args['channelName'],
        );
      default:
        return const Scaffold(body: Center(child: Text('Ruta no encontrada')));
    }
  }

  // Traditional way to navigate using named routes
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case welcomeRoute:
        return MaterialPageRoute(builder: (_) => const WelcomeScreen());

      case registerRoute:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());

      case termsRoute:
        return MaterialPageRoute(
            builder: (_) => const TermsAndConditionsScreen());

      case userTypeRoute:
        return MaterialPageRoute(
            builder: (_) => const UserTypeSelectionScreen());

      case requesterInterestsRoute:
        return MaterialPageRoute(
            builder: (_) => const RequesterInterestsScreen());

      case registrationCompletedRoute:
        return MaterialPageRoute(
            builder: (_) => const RegistrationCompletedScreen());

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
