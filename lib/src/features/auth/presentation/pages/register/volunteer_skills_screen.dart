import 'package:flutter/material.dart';

import '../../../../../common/animations/animated_route.dart';
import '../../widgets/selectable_options_widget.dart';
import '../../../../../routing/app_router.dart';

class VolunteerSkillsScreen extends StatelessWidget {
  const VolunteerSkillsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SelectableOptionsWidgetScreen(
      title: '¿En qué áreas puedes brindar ayuda?',
      subtitle: 'Puedes marcar más de una opción',
      options: const [
        'Asistencia general',
        'Soporte tecnológico',
        'Acompañamiento emocional',
        'Lectura de documentos',
        'Uso de electrodomésticos',
        'Identificación de objetos o lugares',
        'Trámites digitales',
        'Consejos prácticos o tutoriales',
      ],
      finishButtonText: 'Finalizar registro',
      onFinish: () {
        // TODO: guardar selección
        Navigator.of(context).push(animatedRouteTo(
          context,
          AppRouter.registrationCompletedVolunteerRoute,
          duration: const Duration(milliseconds: 300),
          type: RouteTransitionType.pureFade,
          curve: Curves.easeInOut,
        ));
      },
    );
  }
}
