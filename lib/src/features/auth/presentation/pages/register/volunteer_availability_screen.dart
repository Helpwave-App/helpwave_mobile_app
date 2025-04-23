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
        AppRouter.homeVolunteerRoute,
        duration: const Duration(milliseconds: 1000),
        type: RouteTransitionType.pureFade,
        curve: Curves.easeInOutBack,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      body: Column(
        children: [
          const SizedBox(height: 80),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back,
                        color: Theme.of(context).colorScheme.surface),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Disponibilidad',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.surface,
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
                color: Theme.of(context).colorScheme.surface,
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
                        style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.onTertiary),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _onNextPressed,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      backgroundColor: Theme.of(context).colorScheme.tertiary,
                    ),
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
