import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../localization/codegen_loader.g.dart';
import '../../../common/utils/constants/providers.dart';
import '../../../routing/app_router.dart';

class ReviewScreen extends ConsumerWidget {
  final int idVideocall;

  const ReviewScreen({super.key, required this.idVideocall});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            LocaleKeys.reviews_review_screen_appbar_title.tr(),
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Theme.of(context).colorScheme.secondary,
          foregroundColor: Theme.of(context).colorScheme.onSecondary,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 44),
          child: _ReviewForm(idVideocall: idVideocall),
        ),
      ),
    );
  }
}

class _ReviewForm extends ConsumerWidget {
  final int idVideocall;

  const _ReviewForm({required this.idVideocall});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context).colorScheme;
    final controller = ref.watch(reviewControllerProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Text(
            LocaleKeys.reviews_review_screen_form_title.tr(),
            style: const TextStyle(fontSize: 24),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: Text(
            LocaleKeys.reviews_review_screen_form_subtitle.tr(),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18),
          ),
        ),
        const SizedBox(height: 42),
        Text(
          LocaleKeys.reviews_review_screen_form_volunteer_rating.tr(),
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 12),
        AbsorbPointer(
          absorbing: controller.isSubmitting,
          child: RatingBar.builder(
            initialRating: controller.volunteerRating,
            minRating: 0,
            allowHalfRating: false,
            itemCount: 5,
            itemBuilder: (context, _) =>
                const Icon(Icons.star, color: Colors.amber),
            onRatingUpdate:
                ref.read(reviewControllerProvider).setVolunteerRating,
          ),
        ),
        const SizedBox(height: 32),
        Text(
          LocaleKeys.reviews_review_screen_form_call_rating.tr(),
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 12),
        AbsorbPointer(
          absorbing: controller.isSubmitting,
          child: RatingBar.builder(
            initialRating: controller.callRating,
            minRating: 0,
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
          decoration: InputDecoration(
            labelText: LocaleKeys.reviews_review_screen_form_comment_label.tr(),
            border: const OutlineInputBorder(),
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
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(LocaleKeys
                                .reviews_review_screen_snackbar_success
                                .tr()),
                          ),
                        );
                        if (!context.mounted) return;
                        Navigator.pushReplacementNamed(
                            context, AppRouter.loadingRoute);
                      } else {
                        if (!context.mounted) return;
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
                  ? CircularProgressIndicator(color: theme.onPrimary)
                  : Text(
                      LocaleKeys.reviews_review_screen_form_submit_button.tr()),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: controller.isSubmitting
                  ? null
                  : () {
                      Navigator.pushNamed(
                        context,
                        AppRouter.reportRoute,
                        arguments: idVideocall,
                      );
                    },
              icon: Icon(Icons.flag_outlined, color: theme.tertiary),
              label: Text(
                  LocaleKeys.reviews_review_screen_form_report_button.tr()),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF8BC34A)),
                foregroundColor: const Color(0xFF8BC34A),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              LocaleKeys.reviews_review_screen_form_report_hint.tr(),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }
}
