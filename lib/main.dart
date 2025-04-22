import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/constants/app_theme.dart';
import 'src/routing/app_router.dart';

void main() {
  runApp(const ProviderScope(child: HelpWaveApp()));
}

class HelpWaveApp extends StatelessWidget {
  const HelpWaveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HelpWave',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      initialRoute: AppRouter.welcomeRoute,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
