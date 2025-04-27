import 'package:flutter/material.dart';

import '../../../../../common/animations/animated_route.dart';
import '../../../../../routing/app_router.dart';

class VolunteerSkillsScreen extends StatefulWidget {
  const VolunteerSkillsScreen({super.key});

  @override
  State<VolunteerSkillsScreen> createState() => _VolunteerSkillsScreenState();
}

class _VolunteerSkillsScreenState extends State<VolunteerSkillsScreen> {
  final Set<String> _selectedOptions = {};

  final List<String> _options = const [
    'Soporte tecnológico',
    'Acompañamiento emocional',
    'Lectura de documentos',
    'Uso de electrodomésticos',
    'Identificación de objetos o lugares',
    'Trámites digitales',
    'Consejos prácticos o tutoriales',
  ];

  void _onOptionToggled(String option) {
    setState(() {
      if (_selectedOptions.contains(option)) {
        _selectedOptions.remove(option);
      } else {
        _selectedOptions.add(option);
      }
    });
  }

  void _onFinish() {
    // TODO: guardar selección
    Navigator.of(context).push(animatedRouteTo(
      context,
      AppRouter.volunteerAvailabilityRoute,
      duration: const Duration(milliseconds: 300),
      type: RouteTransitionType.pureFade,
      curve: Curves.easeInOut,
    ));
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
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: theme.surface),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    '¿En qué áreas puedes brindar ayuda?',
                    style: TextStyle(
                      color: theme.surface,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Puedes marcar más de una opción',
                    style: TextStyle(
                      fontSize: 16,
                      color: theme.onTertiary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.separated(
                      itemCount: _options.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final option = _options[index];
                        final isSelected = _selectedOptions.contains(option);

                        return GestureDetector(
                          onTap: () => _onOptionToggled(option),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? theme.tertiary.withOpacity(0.2)
                                  : theme.surface.withOpacity(0.1),
                              border: Border.all(
                                color: isSelected
                                    ? theme.tertiary
                                    : theme.primary.withOpacity(0.3),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  isSelected
                                      ? Icons.check_circle
                                      : Icons.circle_outlined,
                                  color: isSelected
                                      ? theme.tertiary
                                      : theme.primary.withOpacity(0.6),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    option,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: theme.onTertiary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _selectedOptions.isNotEmpty ? _onFinish : null,
                    child: const Text('Siguiente'),
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
