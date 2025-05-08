import 'package:flutter/material.dart';
import 'package:helpwave_mobile_app/src/routing/app_router.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
      body: Padding(
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
            ListTile(
              leading: const Icon(Icons.star_outline),
              title: const Text('Habilidades'),
              onTap: () {
                Navigator.of(context).pushNamed(AppRouter.skillsRoute);
              },
            ),
            ListTile(
              leading: const Icon(Icons.schedule),
              title: const Text('Disponibilidad'),
              onTap: () {
                Navigator.of(context).pushNamed(AppRouter.availabilityRoute);
              },
            ),
          ],
        ),
      ),
    );
  }
}
