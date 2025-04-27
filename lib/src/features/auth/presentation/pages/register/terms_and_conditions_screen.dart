import 'package:flutter/material.dart';

import '../../../../../common/animations/animated_route.dart';
import '../../../../../routing/app_router.dart';
import 'user_type_selection_screen.dart';

class TermsAndConditionsScreen extends StatefulWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  State<TermsAndConditionsScreen> createState() =>
      _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {
  bool _accepted = false;
  late final UserType userType;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final typeString = args?['userType'] as String?;
    if (typeString == 'volunteer') {
      userType = UserType.volunteer;
    } else {
      userType = UserType.requester;
    }
  }

  void _onCheckboxChanged(bool? value) {
    setState(() {
      _accepted = value ?? false;
    });
  }

  void _onNextPressed() {
    if (_accepted) {
      final route = userType == UserType.volunteer
          ? AppRouter.signUpVolunteerRoute
          : AppRouter.signUpRequesterRoute;

      Navigator.of(context).push(animatedRouteTo(context, route,
          duration: const Duration(milliseconds: 300),
          type: RouteTransitionType.pureFade,
          curve: Curves.easeInOut));
    }
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
                    'Términos y condiciones',
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
                        'Al usar esta aplicación, aceptas participar de una comunidad basada en el respeto, la colaboración y la ayuda mutua.\n\n'
                        'Te comprometes a brindar y recibir asistencia con buena voluntad, a respetar la privacidad de los demás usuarios y a utilizar esta plataforma exclusivamente para los fines permitidos.\n\n'
                        'HelpWave no se responsabiliza por el contenido de las interacciones, pero se reserva el derecho de suspender cuentas en caso de mal uso.',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: _accepted,
                        onChanged: _onCheckboxChanged,
                      ),
                      Expanded(
                        child: Text(
                          'He leído y acepto los términos y condiciones.',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _accepted ? _onNextPressed : null,
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
