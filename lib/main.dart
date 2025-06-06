import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';

import 'src/common/utils/constants/app_theme.dart';
import 'src/common/utils/firebase/fcm_config.dart';
import 'src/common/utils/firebase/firebase_options.dart';
import 'src/features/notifications/services/firebase_messaging_help_request_handler.dart';
import 'src/features/notifications/services/firebase_messaging_videocall_handler.dart';
import 'src/features/notifications/services/notification_service.dart';
import 'src/routing/app_router.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await NotificationService.initialize();
  await FcmConfig.initializeFCM(requestPermission: false);

  setupHelpRequestNotificationHandler(navigatorKey);
  setupVideocallNotificationHandler(navigatorKey);

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('es')],
      path: 'lib/localization',
      fallbackLocale: const Locale('es'),
      child: const ProviderScope(child: HelpWaveApp()),
    ),
  );
}

class HelpWaveApp extends StatelessWidget {
  const HelpWaveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'HelpWave',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      initialRoute: AppRouter.loadingRoute,
      onGenerateRoute: AppRouter.generateRoute,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
    );
  }
}
