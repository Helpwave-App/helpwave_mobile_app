class ReviewModel {
  final int idVideocall;
  final int scoreVolunteer;
  final String? descriptionComment;
  final int? scoreVideocall;

  ReviewModel({
    required this.idVideocall,
    this.descriptionComment,
    required this.scoreVolunteer,
    this.scoreVideocall,
  });

  Map<String, dynamic> toJson() {
    return {
      'idVideocall': idVideocall,
      'descriptionComment': descriptionComment,
      'scoreVolunteer': scoreVolunteer,
      'scoreVideocall': scoreVideocall,
    };
  }
}
