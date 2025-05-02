import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:helpwave_mobile_app/src/utils/providers.dart';
import 'package:helpwave_mobile_app/src/routing/app_router.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text(
          'Configuración',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: theme.colorScheme.secondary,
        foregroundColor: theme.colorScheme.onSecondary,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Editar perfil'),
              onTap: () {
                // Navegar a editar perfil
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Notificaciones'),
              onTap: () {
                // Navegar a notificaciones
              },
            ),
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text('Centro de ayuda'),
              onTap: () {
                // Navegar al centro de ayuda
              },
            ),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Cerrar sesión',
                  style: TextStyle(color: Colors.red)),
              onTap: () async {
                final authService = ref.read(authServiceProvider);
                await authService.logout();
                if (context.mounted) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    AppRouter.loginRoute,
                    (route) => false,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
