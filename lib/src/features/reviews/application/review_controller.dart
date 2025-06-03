import 'package:flutter/material.dart';
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
      return 'El comentario no puede estar vacío.';
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

      // Limpiar valores después de enviar
      volunteerRating = 1;
      callRating = 1;
      commentController.clear();

      isSubmitting = false;
      notifyListeners();

      return null;
    } catch (e) {
      isSubmitting = false;
      notifyListeners();
      return 'Error al enviar la reseña: $e';
    }
  }
}
