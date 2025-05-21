import 'dart:async';
import 'package:flutter/material.dart';
import '../../../routing/app_router.dart';

class ConnectingScreen extends StatefulWidget {
  const ConnectingScreen({super.key});

  @override
  State<ConnectingScreen> createState() => _ConnectingScreenState();
}

class _ConnectingScreenState extends State<ConnectingScreen> {
  final List<String> tips = [
    'Recuerda tener buena iluminación para que te vean mejor.',
    'Mantén tu cámara enfocando el objeto o situación con la que necesitas ayuda.',
    'Habla con claridad y despacio, especialmente si tu conexión es lenta.',
    'Si no entiendes algo, puedes pedir que te lo repitan sin problema.',
    'Ten a la mano lo que necesitas para aprovechar mejor la videollamada.',
  ];

  int currentTipIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTipsRotation();
  }

  void _startTipsRotation() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        currentTipIndex = (currentTipIndex + 1) % tips.length;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _cancelAndReturnToHome() {
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRouter.homeRequesterRoute,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 80,
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Conectando...',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
        ),
        elevation: 0,
        backgroundColor: theme.colorScheme.secondary,
        foregroundColor: theme.colorScheme.onSecondary,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Estableciendo conexión...',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Estamos buscando la mejor asistencia para ti.',
                style: theme.textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: Text(
                  tips[currentTipIndex],
                  key: ValueKey(currentTipIndex),
                  style: theme.textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _cancelAndReturnToHome,
                  child: const Text('Cancelar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
