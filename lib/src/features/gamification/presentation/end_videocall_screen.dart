import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../localization/codegen_loader.g.dart';
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

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: theme.surface,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            LocaleKeys.gamification_endVideocall_title.tr(),
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
                                  Text(
                                    LocaleKeys
                                        .gamification_endVideocall_congrats
                                        .tr(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
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
                                            color: theme.onTertiary),
                                        children: [
                                          TextSpan(
                                            text: LocaleKeys
                                                .gamification_endVideocall_progressInfo
                                                .tr(namedArgs: {
                                              'assistances': levelProgress
                                                  .assistances
                                                  .toString(),
                                              'missing': levelProgress
                                                  .missingAssistances
                                                  .toString(),
                                            }),
                                          ),
                                          TextSpan(
                                            text:
                                                '"${levelProgress.nextLevel}".',
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
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                              ),
                              child: Text(LocaleKeys
                                  .gamification_endVideocall_goHome
                                  .tr()),
                            ),
                            const SizedBox(height: 12),
                            OutlinedButton.icon(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRouter.reportRoute,
                                  arguments: idVideocall,
                                );
                              },
                              icon: Icon(Icons.flag_outlined,
                                  color: theme.tertiary),
                              label: Text(LocaleKeys
                                  .gamification_endVideocall_report
                                  .tr()),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: theme.tertiary),
                                foregroundColor: theme.tertiary,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              LocaleKeys.gamification_endVideocall_reportHint
                                  .tr(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.grey),
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
              LocaleKeys.gamification_endVideocall_error.tr(namedArgs: {
                'error': error.toString(),
              }),
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ),
      ),
    );
  }
}
