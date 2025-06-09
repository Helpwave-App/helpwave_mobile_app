import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';

import 'src/common/utils/constants/app_theme.dart';
import 'src/common/utils/firebase/fcm_config.dart';
import 'src/common/utils/firebase/firebase_options.dart';
import 'src/features/notifications/services/firebase_messaging_handler.dart';
import 'src/features/notifications/services/notification_service.dart';
import 'src/routing/app_router.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// Background message handler - MUST be a top-level function
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Initialize Firebase if not already initialized
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  print('📩 Background Notification received: ${message.data}');

  // Handle background notification here
  // You can show local notifications, update app state, etc.
  final data = message.data;
  final type = data['type'];

  switch (type) {
    case 'help_request':
      // Handle help request in background
      print('🤝 Background help request received');
      break;
    case 'videocall_start':
      // Handle videocall start in background
      print('📞 Background videocall start received');
      break;
    case 'videocall_end':
      // Handle videocall end in background
      print('📴 Background videocall end received');
      break;
    default:
      print('🔔 Unknown background notification type: $type');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  Locale determineStartLocale() {
    final deviceLocale = PlatformDispatcher.instance.locale;
    if (deviceLocale.languageCode.toLowerCase().startsWith('es')) {
      return const Locale('es');
    } else {
      return const Locale('en');
    }
  }

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Register the background message handler BEFORE other Firebase initialization
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await NotificationService.initialize();
  await FcmConfig.initializeFCM(requestPermission: false);

  setupFirebaseNotificationHandler(navigatorKey);

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('es')],
      path: 'lib/localization',
      fallbackLocale: const Locale('es'),
      startLocale: determineStartLocale(),
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
