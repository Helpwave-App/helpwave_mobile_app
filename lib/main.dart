import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';

import 'src/common/utils/constants/app_theme.dart';
import 'src/common/utils/constants/providers.dart';
import 'src/common/utils/firebase/fcm_config.dart';
import 'src/common/utils/firebase/firebase_options.dart';
import 'src/features/notifications/services/device_token_service.dart';
import 'src/features/notifications/services/firebase_messaging_handler.dart';
import 'src/features/notifications/services/notification_service.dart';
import 'src/routing/app_router.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  print('📩 Background Notification received: ${message.data}');

  final data = message.data;
  final type = data['type'];

  switch (type) {
    case 'help_request':
      print('🤝 Background help request received');
      break;
    case 'videocall_start':
      print('📞 Background videocall start received');
      break;
    case 'videocall_end':
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

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await NotificationService.initialize();
  await FcmConfig.initializeFCM(requestPermission: false);

  setupFirebaseNotificationHandler(navigatorKey);
  DeviceTokenService.setupTokenRefreshListener();

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

class HelpWaveApp extends ConsumerWidget {
  const HelpWaveApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      title: 'HelpWave',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      initialRoute: AppRouter.loadingRoute,
      onGenerateRoute: AppRouter.generateRoute,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
    );
  }
}
