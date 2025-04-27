import 'package:flutter/material.dart';

import '../../../../../common/animations/animated_route.dart';
import '../../../../../routing/app_router.dart';

class VolunteerAvailabilityScreen extends StatefulWidget {
  const VolunteerAvailabilityScreen({super.key});

  @override
  State<VolunteerAvailabilityScreen> createState() =>
      _VolunteerAvailabilityScreenState();
}

class _VolunteerAvailabilityScreenState
    extends State<VolunteerAvailabilityScreen> {
  void _onNextPressed() {
    Navigator.of(context).push(
      animatedRouteTo(
        context,
        AppRouter.registrationCompletedVolunteerRoute,
        duration: const Duration(milliseconds: 1000),
        type: RouteTransitionType.pureFade,
        curve: Curves.easeInOutBack,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: theme.secondary,
      body: Column(
        children: [
          const SizedBox(height: 80),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: theme.surface),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Disponibilidad',
                    style: TextStyle(
                      color: theme.surface,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )),
          const SizedBox(height: 16),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.surface,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        "¿En qué días y horarios puedes brindar ayuda?",
                        style: TextStyle(fontSize: 16, color: theme.onTertiary),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _onNextPressed,
                    child: const Text('Finalizar registro'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
