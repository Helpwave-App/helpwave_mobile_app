import 'package:flutter/material.dart';
import 'package:helpwave_mobile_app/src/features/reports/presentation/report_screen.dart';
import 'package:helpwave_mobile_app/src/features/reviews/presentation/review_screen.dart';
import 'package:helpwave_mobile_app/src/features/availability/presentation/user_availability_screen.dart';
import 'package:helpwave_mobile_app/src/features/settings/presentation/pages/help_center_screen.dart';

import '../common/pages/loading_screen.dart';
import '../features/auth/presentation/pages/permissions_screen.dart';
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
import '../features/gamification/presentation/end_videocall_screen.dart';
import '../features/home/presentation/pages/home_requester_screen.dart';
import '../features/home/presentation/pages/home_volunteer_screen.dart';
import '../features/language/presentation/user_languages_screen.dart';
import '../features/settings/presentation/pages/settings_screen.dart';
import '../features/videocalls/presentation/connecting_screen.dart';
import '../features/videocalls/presentation/videocall_screen.dart';
import '../features/settings/presentation/settings_options_screen.dart';
import '../features/settings/presentation/pages/profile_screen.dart';
import '../features/profile/presentation/user_info_screen.dart';
import '../features/skills/presentation/user_skills_screen.dart';
import '../features/requests/presentation/request_history_screen.dart';

class AppRouter {
  static const String loadingRoute = '/';
  static const String welcomeRoute = '/welcome';
  static const String permissionsRoute = '/permissions';
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
  static const String connectingRoute = '/connecting';
  static const String videoCallRoute = '/videocall';
  static const String reviewRoute = '/review';
  static const String reportRoute = '/report';
  static const String endVideocallRoute = '/videocall-end';
  static const String settingsOptionsRoute = '/settings-options';
  static const String settingsRoute = '/settings';
  static const String languageRoute = '/language-user';
  static const String helpCenterRoute = '/help-center';
  static const String profileRoute = '/profile';
  static const String userInfoRoute = '/user-info';
  static const String skillsRoute = '/skills';
  static const String availabilityRoute = '/availability';
  static const String requestHistoryRoute = '/request-history';

  static Widget? getPageFromRoute(String routeName,
      {Map<String, dynamic>? args}) {
    switch (routeName) {
      case loadingRoute:
        return const LoadingScreen();

      case welcomeRoute:
        return const WelcomeScreen();

      case permissionsRoute:
        return const PermissionsScreen();

      case signUpRequesterRoute:
        return const SignUpRequesterScreen();

      case signUpVolunteerRoute:
        return const SignUpVolunteerScreen();

      case termsRoute:
        return const TermsAndConditionsScreen();

      case userTypeRoute:
        return const UserTypeSelectionScreen();

      case volunteerSkillsRoute:
        return VolunteerSkillsScreen(
            idProfile: args?['idProfile'] as int? ?? 0,
            username: args?['username'],
            password: args?['password']);

      case volunteerAvailabilityRoute:
        return VolunteerAvailabilityScreen(
            idProfile: args?['idProfile'] as int? ?? 0,
            username: args?['username'],
            password: args?['password']);

      case registrationCompletedRequesterRoute:
        return const RegistrationCompletedRequesterScreen();

      case registrationCompletedVolunteerRoute:
        return const RegistrationCompletedVolunteerScreen();

      case loginRoute:
        return const SignInScreen();

      case homeRequesterRoute:
        return const HomeRequesterScreen();

      case homeVolunteerRoute:
        return HomeVolunteerScreen(
          onDialogRequested: () {},
        );

      case connectingRoute:
        return ConnectingScreen(
          idRequest: args?['idRequest'] as int? ?? 0,
        );

      case videoCallRoute:
        if (args == null ||
            !args.containsKey('token') ||
            !args.containsKey('channel') ||
            !args.containsKey('fullname') ||
            !args.containsKey('idVideocall')) {
          return const Scaffold(body: Center(child: Text('Faltan argumentos')));
        }
        return VideoCallScreen(
          token: args['token'],
          channel: args['channel'],
          fullname: args['fullname'],
          idVideocall: args['idVideocall'] as int? ?? 0,
        );

      case reviewRoute:
        if (args == null || !args.containsKey('idVideocall')) {
          return const Scaffold(body: Center(child: Text('Faltan argumentos')));
        }
        return ReviewScreen(idVideocall: args['idVideocall'] as int? ?? 0);

      case endVideocallRoute:
        if (args == null || !args.containsKey('idVideocall')) {
          return const Scaffold(body: Center(child: Text('Faltan argumentos')));
        }
        return EndVideocallScreen(idVideocall: args['idVideocall'] as int);

      case reportRoute:
        if (args == null || !args.containsKey('idVideocall')) {
          return const Scaffold(body: Center(child: Text('Faltan argumentos')));
        }
        return ReportScreen(idVideocall: args['idVideocall'] as int);

      case settingsOptionsRoute:
        return const SettingsOptionsScreen();

      case settingsRoute:
        return const SettingsScreen();

      case languageRoute:
        return const UserLanguagesScreen();

      case helpCenterRoute:
        return const HelpCenterScreen();

      case profileRoute:
        return const ProfileScreen();

      case userInfoRoute:
        return const UserInfoScreen();

      case skillsRoute:
        return const UserSkillsScreen();

      case availabilityRoute:
        return const UserAvailabilityScreen();

      default:
        return const Scaffold(body: Center(child: Text('Ruta no encontrada')));
    }
  }

  // Traditional way to navigate using named routes
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loadingRoute:
        return MaterialPageRoute(builder: (_) => const LoadingScreen());

      case welcomeRoute:
        return MaterialPageRoute(builder: (_) => const WelcomeScreen());

      case permissionsRoute:
        return MaterialPageRoute(builder: (_) => const PermissionsScreen());

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
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => VolunteerSkillsScreen(
              idProfile: args != null ? args['idProfile'] as int : 0,
              username: args != null ? args['username'] as String : '',
              password: args != null ? args['password'] as String : ''),
        );

      case volunteerAvailabilityRoute:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => VolunteerAvailabilityScreen(
              idProfile: args != null ? args['idProfile'] as int : 0,
              username: args != null ? args['username'] as String : '',
              password: args != null ? args['password'] as String : ''),
        );

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
        return MaterialPageRoute(
            builder: (_) => HomeVolunteerScreen(
                  onDialogRequested: () {},
                ));

      case connectingRoute:
        final idRequest = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => ConnectingScreen(idRequest: idRequest),
        );

      case videoCallRoute:
        final args = settings.arguments as Map<String, dynamic>;
        final token = args['token'] as String;
        final channelName = args['channel'] as String;
        final fullname = args['fullname'] as String;
        final idVideocall = args['idVideocall'] as int? ?? 0;

        return MaterialPageRoute(
          builder: (_) => VideoCallScreen(
              token: token,
              channel: channelName,
              fullname: fullname,
              idVideocall: idVideocall),
        );

      case reviewRoute:
        final idVideocall = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => ReviewScreen(idVideocall: idVideocall),
        );

      case endVideocallRoute:
        final idVideocall = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => EndVideocallScreen(idVideocall: idVideocall),
        );

      case reportRoute:
        final idVideocall = settings.arguments as int;
        return MaterialPageRoute(
            builder: (_) => ReportScreen(idVideocall: idVideocall));

      case settingsOptionsRoute:
        return MaterialPageRoute(builder: (_) => const SettingsOptionsScreen());

      case settingsRoute:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());

      case languageRoute:
        return MaterialPageRoute(builder: (_) => const UserLanguagesScreen());

      case helpCenterRoute:
        return MaterialPageRoute(builder: (_) => const HelpCenterScreen());

      case profileRoute:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());

      case userInfoRoute:
        return MaterialPageRoute(builder: (_) => const UserInfoScreen());

      case skillsRoute:
        return MaterialPageRoute(builder: (_) => const UserSkillsScreen());

      case availabilityRoute:
        return MaterialPageRoute(
            builder: (_) => const UserAvailabilityScreen());

      case requestHistoryRoute:
        return MaterialPageRoute(builder: (_) => const RequestHistoryScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Ruta no encontrada')),
          ),
        );
    }
  }
}
