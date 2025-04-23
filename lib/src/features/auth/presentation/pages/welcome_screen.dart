import 'package:flutter/material.dart';

import '../../../../common/animations/animated_route.dart';
import '../../../../routing/app_router.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      body: Column(
        children: [
          const SizedBox(height: 100),
          Center(
            child: Column(
              children: [
                Hero(
                  tag: 'app-logo',
                  child: CircleAvatar(
                    radius: 48,
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    child: Icon(
                      Icons.volunteer_activism,
                      color: Theme.of(context).colorScheme.tertiary,
                      size: 48,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Bienvenido a HelpWave',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.surface,
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    'Una comunidad donde ayudar y recibir ayuda es parte de lo mismo: cuidarnos entre todos.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .surface
                          .withOpacity(0.9),
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(animatedRouteTo(
                        context, AppRouter.loginRoute,
                        curve: Curves.easeInOutBack));
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    backgroundColor: Theme.of(context).colorScheme.tertiary,
                  ),
                  child: const Text("Iniciar sesión"),
                ),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).push(animatedRouteTo(
                        context, AppRouter.registerRoute,
                        curve: Curves.easeInOutBack));
                  },
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    foregroundColor: Theme.of(context).colorScheme.tertiary,
                    side: BorderSide(
                        color: Theme.of(context).colorScheme.tertiary),
                  ),
                  child: const Text("Crear cuenta"),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
