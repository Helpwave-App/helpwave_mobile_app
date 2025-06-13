import 'package:flutter/material.dart';

import '../../../common/utils/firebase/firebase_options.dart';
import '../domain/level_progress.dart';

class InsigniaProgressWidget extends StatelessWidget {
  final LevelProgressModel levelProgress;
  final double progress;
  final int percentage;

  const InsigniaProgressWidget({
    super.key,
    required this.levelProgress,
    required this.progress,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Image.network(
                      '$imageBaseUrl${levelProgress.currentLevelPhotoUrl}',
                      width: 48,
                      height: 48,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.error, size: 48),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      levelProgress.currentLevel,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          Container(
                            height: 12,
                            decoration: BoxDecoration(
                              color: theme.onTertiary.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          FractionallySizedBox(
                            widthFactor: progress.clamp(0.0, 1.0),
                            child: Container(
                              height: 12,
                              decoration: BoxDecoration(
                                color: theme.secondary,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$percentage%',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  children: [
                    Image.network(
                      '$imageBaseUrl${levelProgress.nextLevelPhotoUrl}',
                      width: 48,
                      height: 48,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.error, size: 48),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      levelProgress.nextLevel,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
