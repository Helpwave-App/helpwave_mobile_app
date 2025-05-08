import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../routing/app_router.dart';
import '../../../utils/providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final authService = ref.read(authServiceProvider);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text(
          'Mi perfil',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: theme.colorScheme.secondary,
        foregroundColor: theme.colorScheme.onSecondary,
        elevation: 0,
      ),
      body: FutureBuilder<String?>(
        future: authService.getUserRole(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          final role = snapshot.data;
          final isVolunteer = role == 'volunteer';

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('Información de usuario'),
                  onTap: () {
                    Navigator.of(context).pushNamed(AppRouter.userInfoRoute);
                  },
                ),
                if (isVolunteer)
                  ListTile(
                    leading: const Icon(Icons.star_outline),
                    title: const Text('Habilidades'),
                    onTap: () {
                      Navigator.of(context).pushNamed(AppRouter.skillsRoute);
                    },
                  ),
                if (isVolunteer)
                  ListTile(
                    leading: const Icon(Icons.schedule),
                    title: const Text('Disponibilidad'),
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed(AppRouter.availabilityRoute);
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
