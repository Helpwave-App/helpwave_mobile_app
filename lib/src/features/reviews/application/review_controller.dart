import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../localization/codegen_loader.g.dart';
import '../data/review_service.dart';
import '../domain/review_model.dart';

class ReviewController extends ChangeNotifier {
  final ReviewService reviewService = ReviewService();

  double volunteerRating = 0;
  double callRating = 0;

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
    if (volunteerRating == 0 || callRating == 0) {
      return 'Debe indicar una calificación';
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

      volunteerRating = 0;
      callRating = 0;
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
