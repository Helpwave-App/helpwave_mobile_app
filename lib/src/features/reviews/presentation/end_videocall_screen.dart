import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:helpwave_mobile_app/src/routing/app_router.dart';

class EndVideocallScreen extends ConsumerWidget {
  final int idVideocall;

  const EndVideocallScreen({super.key, required this.idVideocall});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            const Center(
              child: Text(
                'Ayúdanos a mejorar',
                style: TextStyle(fontSize: 24),
              ),
            ),
            const SizedBox(height: 8),
            const Center(
              child: Text(
                'Si ocurrió algún incidente durante la asistencia, por favor, comunícalo inmediatamente para poder brindar una solución.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 42),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
