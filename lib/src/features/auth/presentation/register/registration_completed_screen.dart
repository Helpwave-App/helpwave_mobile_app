import 'package:flutter/material.dart';

import '../../../../common/animations/animated_route.dart';
import '../../../../routing/app_router.dart';

class RegistrationCompletedScreen extends StatelessWidget {
  const RegistrationCompletedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              const Spacer(),
              Icon(
                Icons.volunteer_activism,
                color: theme.colorScheme.secondary,
                size: 90,
              ),
              const SizedBox(height: 32),
              Text(
                '¡Te has registrado con éxito!',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                'Bienvenido a HelpWave. Aquí encontrarás voluntarios listos para ayudarte con lo que necesites, cuando lo necesites.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontSize: 18,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Gracias por ser parte de esta comunidad solidaria.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    backgroundColor: theme.colorScheme.tertiary,
                    foregroundColor: theme.colorScheme.onTertiary,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(animatedRouteTo(
                        context, AppRouter.homeRoute,
                        type: RouteTransitionType.pureFade,
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.easeInOutBack));
                  },
                  child: const Text(
                    'Ir al inicio',
                    style: TextStyle(fontSize: 20),
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
