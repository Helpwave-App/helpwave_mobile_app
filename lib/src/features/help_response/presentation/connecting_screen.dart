import 'dart:async';
import 'package:flutter/material.dart';
import 'package:helpwave_mobile_app/src/features/help_response/data/videocall_service.dart';
import '../../../routing/app_router.dart';

class ConnectingScreen extends StatefulWidget {
  final int idRequest;

  const ConnectingScreen({super.key, required this.idRequest});

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

  void _cancelAndReturnToHome() async {
    final service = VideocallService();

    try {
      await service.cancelRequest(widget.idRequest);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo cancelar la solicitud')),
      );
    }

    if (!mounted) return;

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
                  onPressed: _showCancelConfirmationDialog,
                  child: const Text('Cancelar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCancelConfirmationDialog() {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: theme.colorScheme.surface,
          title: Text(
            'Cancelar solicitud',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          content: Text(
            '¿Estás seguro de que deseas cancelar tu solicitud de ayuda?',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          actionsPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          actionsAlignment: MainAxisAlignment.end,
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: theme.colorScheme.primary,
                textStyle: theme.textTheme.labelLarge,
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('No'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.error,
                foregroundColor: theme.colorScheme.onError,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                textStyle: theme.textTheme.labelLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _cancelAndReturnToHome();
              },
              child: const Text('Sí, cancelar'),
            ),
          ],
        );
      },
    );
  }
}
