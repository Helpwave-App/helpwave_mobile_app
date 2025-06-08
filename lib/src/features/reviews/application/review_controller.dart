import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../localization/codegen_loader.g.dart';
import '../data/review_service.dart';
import '../domain/review_model.dart';

class ReviewController extends ChangeNotifier {
  final ReviewService reviewService = ReviewService();

  double volunteerRating = 1;
  double callRating = 1;

  final TextEditingController commentController = TextEditingController();

  bool isSubmitting = false;

  void setVolunteerRating(double rating) {
    volunteerRating = rating;
    notifyListeners();
  }

  void setCallRating(double rating) {
    callRating = rating;
    notifyListeners();
  }

  Future<String?> submitReview(int idVideocall) async {
    if (commentController.text.trim().isEmpty) {
      return LocaleKeys.reviews_review_controller_validation_empty_comment.tr();
    }

    isSubmitting = true;
    notifyListeners();

    try {
      final review = ReviewModel(
        idVideocall: idVideocall,
        scoreVolunteer: volunteerRating,
        scoreVideocall: callRating,
        descriptionComment: commentController.text.trim(),
      );

      await reviewService.submitReview(review);

      volunteerRating = 1;
      callRating = 1;
      commentController.clear();

      isSubmitting = false;
      notifyListeners();

      return null;
    } catch (e) {
      isSubmitting = false;
      notifyListeners();
      return '${LocaleKeys.reviews_review_controller_error_submission.tr()}: $e';
    }
  }
}
