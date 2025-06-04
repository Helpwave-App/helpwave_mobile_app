import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../routing/app_router.dart';
import '../../../utils/constants/providers.dart';

class ReviewScreen extends ConsumerWidget {
  final int idVideocall;

  const ReviewScreen({super.key, required this.idVideocall});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text(
          'Reseña de Videollamada',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        foregroundColor: Theme.of(context).colorScheme.onSecondary,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 44),
        child: _ReviewForm(idVideocall: idVideocall),
      ),
    );
  }
}

class _ReviewForm extends ConsumerWidget {
  final int idVideocall;

  const _ReviewForm({required this.idVideocall});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(reviewControllerProvider);

    return Column(
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
            'Evalúa los siguientes aspectos',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ),
        const SizedBox(height: 42),
        const Text(
          'Puntúa la atención del voluntario*',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 12),
        AbsorbPointer(
          absorbing: controller.isSubmitting,
          child: RatingBar.builder(
            initialRating: controller.volunteerRating,
            minRating: 1,
            allowHalfRating: false,
            itemCount: 5,
            itemBuilder: (context, _) =>
                const Icon(Icons.star, color: Colors.amber),
            onRatingUpdate:
                ref.read(reviewControllerProvider).setVolunteerRating,
          ),
        ),
        const SizedBox(height: 32),
        const Text(
          'Puntúa la videollamada*',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 12),
        AbsorbPointer(
          absorbing: controller.isSubmitting,
          child: RatingBar.builder(
            initialRating: controller.callRating,
            minRating: 1,
            allowHalfRating: false,
            itemCount: 5,
            itemBuilder: (context, _) =>
                const Icon(Icons.star, color: Colors.amber),
            onRatingUpdate: ref.read(reviewControllerProvider).setCallRating,
          ),
        ),
        const SizedBox(height: 32),
        TextFormField(
          controller: controller.commentController,
          maxLines: 4,
          maxLength: 500,
          enabled: !controller.isSubmitting,
          decoration: const InputDecoration(
            labelText: 'Comentario (máximo 500 caracteres)',
            border: OutlineInputBorder(),
            alignLabelWithHint: true,
          ),
        ),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: controller.isSubmitting
                  ? null
                  : () async {
                      final error = await ref
                          .read(reviewControllerProvider)
                          .submitReview(idVideocall);

                      if (error == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Reseña enviada con éxito')),
                        );
                        Navigator.pushReplacementNamed(
                            context, AppRouter.loadingRoute);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(error)),
                        );
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8BC34A),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: controller.isSubmitting
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Enviar reseña'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: controller.isSubmitting
                  ? null
                  : () {
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
      ],
    );
  }
}
