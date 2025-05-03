import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../routing/app_router.dart';

class HomeWidget extends ConsumerWidget {
  final String greeting;
  final String subtitle;
  final String buttonText;

  const HomeWidget({
    super.key,
    required this.greeting,
    required this.subtitle,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 80,
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'HelpWave',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Configuración',
            onPressed: () {
              Navigator.of(context).pushNamed(AppRouter.settingsRoute);
            },
          )
        ],
        elevation: 0,
        backgroundColor: theme.colorScheme.secondary,
        foregroundColor: theme.colorScheme.onSecondary,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            children: [
              const SizedBox(height: 32),
              Text(
                greeting,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Center(
                child: SizedBox(
                  width: 180,
                  height: 180,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: EdgeInsets.zero,
                      backgroundColor: theme.colorScheme.tertiary,
                      foregroundColor: theme.colorScheme.onSecondary,
                      elevation: 6,
                    ),
                    onPressed: () {
                      const String channelName = 'testchannel';
                      const String token =
                          '007eJxTYPCpSvpXxGHIvPq92vIz3Dvtb/68sjTINkHtTc79EE+tlT4KDObJ5qZmJinGSYkmJibmFslJBiapRoZJ5iZGBiYpBomWnB18GQ2BjAx3HRexMjJAIIjPzVCSWlySnJGYl5eaw8AAAPFyIQ0=';

                      Navigator.of(context).pushNamed(
                        AppRouter.videoCallRoute,
                        arguments: {
                          'token': token,
                          'channelName': channelName,
                        },
                      );
                    },
                    child: Text(
                      buttonText,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
