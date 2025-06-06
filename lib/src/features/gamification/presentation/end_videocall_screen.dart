import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/utils/constants/providers.dart';
import '../../../routing/app_router.dart';
import '../domain/level_progress.dart';
import 'insignia_progress_widget.dart';

class EndVideocallScreen extends ConsumerWidget {
  final int idVideocall;

  const EndVideocallScreen({super.key, required this.idVideocall});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context).colorScheme;

    final AsyncValue<LevelProgressModel> levelProgressAsync =
        ref.watch(levelProgressControllerProvider);

    return Scaffold(
      backgroundColor: theme.surface,
      appBar: AppBar(
        title: const Text(
          'Videollamada Finalizada',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: theme.secondary,
        foregroundColor: theme.onSecondary,
        elevation: 0,
      ),
      body: levelProgressAsync.when(
        data: (levelProgress) {
          final total =
              levelProgress.assistances + levelProgress.missingAssistances;
          final double progress =
              total == 0 ? 0.0 : levelProgress.assistances / total;
          final int percentage = (progress * 100).round();

          return LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 38, vertical: 44),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 24),
                          Center(
                            child: Column(
                              children: [
                                Icon(Icons.emoji_events,
                                    size: 64, color: theme.tertiary),
                                const SizedBox(height: 12),
                                const Text(
                                  '¡Gracias por tu ayuda!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 12),
                                Center(
                                  child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: theme
                                              .onTertiary), // Usa el color del tema
                                      children: [
                                        TextSpan(
                                          text:
                                              'Ya has asistido a ${levelProgress.assistances} personas. '
                                              'Estás a ${levelProgress.missingAssistances} asistencias de alcanzar el nivel ',
                                        ),
                                        TextSpan(
                                          text: '"${levelProgress.nextLevel}".',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 36),
                                InsigniaProgressWidget(
                                  levelProgress: levelProgress,
                                  progress: progress,
                                  percentage: percentage,
                                ),
                                const SizedBox(height: 32),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SafeArea(
                    minimum: const EdgeInsets.fromLTRB(38, 0, 38, 0),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 38),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                AppRouter.loadingRoute,
                                (route) => false,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.tertiary,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text('Ir a inicio'),
                          ),
                          const SizedBox(height: 12),
                          OutlinedButton.icon(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, AppRouter.reportRoute);
                            },
                            icon: Icon(Icons.flag_outlined,
                                color: theme.tertiary),
                            label: const Text('Reportar incidente'),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: theme.tertiary),
                              foregroundColor: theme.tertiary,
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
                  ),
                ],
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text(
            'Error al cargar el progreso: $error',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }
}
