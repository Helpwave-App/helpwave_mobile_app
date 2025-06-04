import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:helpwave_mobile_app/src/routing/app_router.dart';

class EndVideocallScreen extends ConsumerWidget {
  final int idVideocall;

  const EndVideocallScreen({super.key, required this.idVideocall});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double progress = 0.7; // Valor dinámico (ej. 7 asistencias de 10)
    final int percentage = (progress * 100).round();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text(
          'Videollamada Finalizada',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        foregroundColor: Theme.of(context).colorScheme.onSecondary,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 38, vertical: 44),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.emoji_events,
                    size: 64,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '¡Gracias por tu ayuda!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Ya has asistido a 7 personas. Estás a 3 asistencias de alcanzar el nivel "Mentor solidario".',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  Center(
                    child: Container(
                      width: 240,
                      height: 240,
                      alignment: Alignment.center,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 120,
                            height: 120,
                            child: CircularProgressIndicator(
                              value: progress,
                              strokeWidth: 16,
                              color: Theme.of(context).colorScheme.secondary,
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .onTertiary
                                  .withOpacity(0.2),
                            ),
                          ),
                          Text(
                            '$percentage%',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRouter.loadingRoute);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8BC34A),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('Ir a inicio'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, AppRouter.reportRoute);
              },
              icon: const Icon(Icons.flag_outlined, color: Color(0xFF8BC34A)),
              label: const Text('Reportar incidente'),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF8BC34A)),
                foregroundColor: const Color(0xFF8BC34A),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              '¿Tuviste algún inconveniente? Puedes reportarlo aquí.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
