import 'package:flutter/material.dart';

import '../../../../../common/animations/animated_route.dart';
import '../../widgets/selectable_options_widget.dart';
import '../../../../../routing/app_router.dart';

class RequesterInterestsScreen extends StatelessWidget {
  const RequesterInterestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SelectableOptionsWidgetScreen(
      title: '¿Cómo qué te gustaría que te ayudemos?',
      subtitle: 'Puedes marcar más de una opción',
      options: const [
        'Asistencia general',
        'Asistencia tecnológica',
        'Verificación de información',
        'Acompañamiento emocional',
        'Apoyo para leer o entender documentos',
        'Ayuda con electrodomésticos',
        'Identificación de objetos o lugares',
        'Orientación en trámites digitales',
      ],
      finishButtonText: 'Finalizar registro',
      onFinish: () {
        // TODO: guardar selección
        Navigator.of(context).push(animatedRouteTo(
          context,
          AppRouter.registrationCompletedRequesterRoute,
          duration: const Duration(milliseconds: 300),
          type: RouteTransitionType.pureFade,
          curve: Curves.easeInOut,
        ));
      },
    );
  }
}
