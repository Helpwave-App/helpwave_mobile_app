import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:helpwave_mobile_app/src/routing/app_router.dart';
import '../../../common/utils/constants/providers.dart';

class EndVideocallScreen extends ConsumerWidget {
  final int idVideocall;
  final int idProfile;

  const EndVideocallScreen({
    super.key,
    required this.idVideocall,
    required this.idProfile,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final levelProgressAsync = ref.watch(levelProgressProvider(idProfile));

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
      body: levelProgressAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (progressData) {
          final double progress = progressData.scoreProfile / 10;
          final int percentage = (progress * 100).round();

          return Padding(
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
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Ya has asistido a ${progressData.assistances} personas. '
                        'Estás a ${progressData.missingAssistances} asistencias de alcanzar el nivel '
                        '"${progressData.nextLevel}".',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 24),
                      Center(
                        child: Container(
                          width: 240,
                          height: 240,
                          alignment: Alignment.center,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: 160,
                                height: 160,
                                child: CircularProgressIndicator(
                                  value: progress.clamp(0.0, 1.0),
                                  strokeWidth: 16,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
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
                  icon:
                      const Icon(Icons.flag_outlined, color: Color(0xFF8BC34A)),
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
          );
        },
      ),
    );
  }
}
