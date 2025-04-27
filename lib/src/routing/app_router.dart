import 'package:flutter/material.dart';

import '../features/auth/presentation/pages/welcome_screen.dart';
import '../features/auth/presentation/pages/login/sign_in_screen.dart';
import '../features/auth/presentation/pages/register/sign_up_requester_screen.dart';
import '../features/auth/presentation/pages/register/sign_up_volunteer_screen.dart';
import '../features/auth/presentation/pages/register/terms_and_conditions_screen.dart';
import '../features/auth/presentation/pages/register/user_type_selection_screen.dart';
import '../features/auth/presentation/pages/register/volunteer_skills_screen.dart';
import '../features/auth/presentation/pages/register/volunteer_availability_screen.dart';
import '../features/auth/presentation/pages/register/registration_completed_requester_screen.dart';
import '../features/auth/presentation/pages/register/registration_completed_volunteer_screen.dart';
import '../features/home/presentation/pages/home_requester_screen.dart';
import '../features/home/presentation/pages/home_volunteer_screen.dart';
import '../features/videocall/presentation/videocall_screen.dart';

class AppRouter {
  static const String welcomeRoute = '/';
  static const String loginRoute = '/login';
  static const String userTypeRoute = '/user-type';
  static const String termsRoute = '/terms-and-conditions';
  static const String signUpRequesterRoute = '/requester-register';
  static const String signUpVolunteerRoute = '/volunteer-register';
  static const String volunteerSkillsRoute = '/volunteer-skills';
  static const String volunteerAvailabilityRoute = '/volunteer-availability';
  static const String registrationCompletedRequesterRoute =
      '/registration-completed-requester';
  static const String registrationCompletedVolunteerRoute =
      '/registration-completed-volunteer';
  static const String homeRequesterRoute = '/home-requester';
  static const String homeVolunteerRoute = '/home-volunteer';
  static const String videoCallRoute = '/videocall';

  static Widget? getPageFromRoute(String routeName,
      {Map<String, dynamic>? args}) {
    switch (routeName) {
      case welcomeRoute:
        return const WelcomeScreen();

      case signUpRequesterRoute:
        return const SignUpRequesterScreen();

      case signUpVolunteerRoute:
        return const SignUpVolunteerScreen();

      case termsRoute:
        return const TermsAndConditionsScreen();

      case userTypeRoute:
        return const UserTypeSelectionScreen();

      case volunteerSkillsRoute:
        return const VolunteerSkillsScreen();

      case volunteerAvailabilityRoute:
        return const VolunteerAvailabilityScreen();

      case registrationCompletedRequesterRoute:
        return const RegistrationCompletedRequesterScreen();

      case registrationCompletedVolunteerRoute:
        return const RegistrationCompletedVolunteerScreen();

      case loginRoute:
        return const SignInScreen();

      case homeRequesterRoute:
        return const HomeRequesterScreen();

      case homeVolunteerRoute:
        return const HomeVolunteerScreen();

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

      case signUpRequesterRoute:
        return MaterialPageRoute(builder: (_) => const SignUpRequesterScreen());

      case signUpVolunteerRoute:
        return MaterialPageRoute(builder: (_) => const SignUpVolunteerScreen());

      case termsRoute:
        return MaterialPageRoute(
            builder: (_) => const TermsAndConditionsScreen());

      case userTypeRoute:
        return MaterialPageRoute(
            builder: (_) => const UserTypeSelectionScreen());

      case volunteerSkillsRoute:
        return MaterialPageRoute(builder: (_) => const VolunteerSkillsScreen());

      case volunteerAvailabilityRoute:
        return MaterialPageRoute(
            builder: (_) => const VolunteerAvailabilityScreen());

      case registrationCompletedRequesterRoute:
        return MaterialPageRoute(
            builder: (_) => const RegistrationCompletedRequesterScreen());

      case registrationCompletedVolunteerRoute:
        return MaterialPageRoute(
            builder: (_) => const RegistrationCompletedVolunteerScreen());

      case loginRoute:
        return MaterialPageRoute(builder: (_) => const SignInScreen());

      case homeRequesterRoute:
        return MaterialPageRoute(builder: (_) => const HomeRequesterScreen());

      case homeVolunteerRoute:
        return MaterialPageRoute(builder: (_) => const HomeVolunteerScreen());

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
