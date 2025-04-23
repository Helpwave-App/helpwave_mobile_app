import 'package:flutter/material.dart';
import '../../../routing/app_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                '¡Hola!',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                '¿Listo para recibir ayuda hoy?',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Botón circular grande
              Center(
                child: SizedBox(
                  width: 180,
                  height: 180,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: EdgeInsets.zero,
                      backgroundColor: theme.colorScheme.tertiary,
                      foregroundColor: theme.colorScheme.onTertiary,
                      elevation: 6,
                    ),
                    onPressed: () {
                      const String channelName = 'testchannel';
                      const String token =
                          '007eJxTYHhlFtV2ad6zJ4ZR5fqWhQfTI0WqC8tYHjo33C/d/zffRUOBwTzZ3NTMJMU4KdHExMTcIjnJwCTVyDDJ3MTIwCTFINFyChdzRkMgI8OJp0tYGRkgEMTnZihJLS5JzkjMy0vNYWAAACPOIeI=';

                      Navigator.of(context).pushNamed(
                        AppRouter.videoCallRoute,
                        arguments: {
                          'token': token,
                          'channelName': channelName,
                        },
                      );
                    },
                    child: const Text(
                      'Solicitar\nasistencia',
                      textAlign: TextAlign.center,
                      style: TextStyle(
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
