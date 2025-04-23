import 'package:flutter/material.dart';

import '../../../../common/animations/animated_route.dart';
import '../../../../routing/app_router.dart';

class RequesterInterestsScreen extends StatefulWidget {
  const RequesterInterestsScreen({super.key});

  @override
  State<RequesterInterestsScreen> createState() =>
      _RequesterInterestsScreenState();
}

class _RequesterInterestsScreenState extends State<RequesterInterestsScreen> {
  final List<String> _options = [
    'Asistencia general',
    'Asistencia tecnológica',
    'Verificación de información',
    'Acompañamiento emocional',
    'Apoyo para leer o entender documentos',
    'Ayuda con electrodomésticos',
    'Identificación de objetos o lugares',
    'Orientación en trámites digitales',
  ];

  final Set<String> _selectedOptions = {};

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
    print('Opciones seleccionadas: $_selectedOptions');
    Navigator.of(context).push(animatedRouteTo(
        context, AppRouter.registrationCompletedRoute,
        duration: const Duration(milliseconds: 300),
        type: RouteTransitionType.pureFade,
        curve: Curves.easeInOut));
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.secondary,
      body: Column(
        children: [
          const SizedBox(height: 80),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: colors.surface),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    '¿Cómo qué te gustaría que te ayudemos?',
                    style: TextStyle(
                      color: colors.surface,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    softWrap: true,
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
                color: colors.surface,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Puedes marcar más de una opción',
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
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
                                  ? colors.tertiary.withOpacity(0.2)
                                  : Colors.grey[100],
                              border: Border.all(
                                color: isSelected
                                    ? colors.tertiary
                                    : Colors.grey[300]!,
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
                                      ? colors.tertiary
                                      : Colors.grey[600],
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    option,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[800],
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
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      backgroundColor: colors.tertiary,
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
