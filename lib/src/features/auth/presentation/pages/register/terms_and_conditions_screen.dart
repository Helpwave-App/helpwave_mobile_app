import 'package:flutter/material.dart';

import '../../../../../common/animations/animated_route.dart';
import '../../../../../routing/app_router.dart';

class TermsAndConditionsScreen extends StatefulWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  State<TermsAndConditionsScreen> createState() =>
      _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {
  bool _accepted = false;

  void _onCheckboxChanged(bool? value) {
    setState(() {
      _accepted = value ?? false;
    });
  }

  void _onNextPressed() {
    if (_accepted) {
      Navigator.of(context).push(animatedRouteTo(
          context, AppRouter.userTypeRoute,
          duration: const Duration(milliseconds: 300),
          type: RouteTransitionType.pureFade,
          curve: Curves.easeInOut));
    }
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
                    'Términos y condiciones',
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
                        // Aquí puedes reemplazar con tu texto real
                        'Al usar esta aplicación, aceptas participar de una comunidad basada en el respeto, la colaboración y la ayuda mutua.\n\n'
                        'Te comprometes a brindar y recibir asistencia con buena voluntad, a respetar la privacidad de los demás usuarios y a utilizar esta plataforma exclusivamente para los fines permitidos.\n\n'
                        'HelpWave no se responsabiliza por el contenido de las interacciones, pero se reserva el derecho de suspender cuentas en caso de mal uso.',
                        style: TextStyle(fontSize: 16, color: Colors.grey[800]),
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
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _accepted ? _onNextPressed : null,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      backgroundColor: Theme.of(context).colorScheme.tertiary,
                    ),
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
