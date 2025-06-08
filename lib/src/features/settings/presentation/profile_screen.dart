import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/utils/constants/providers.dart';
import '../../../routing/app_router.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final userRoleAsync = ref.watch(userRoleProvider);

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
      body: userRoleAsync.when(
        data: (role) {
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
                    ref.invalidate(profileFutureProvider);
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
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error al cargar el rol')),
      ),
    );
  }
}
