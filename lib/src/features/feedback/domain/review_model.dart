class ReviewModel {
  final int idVideocall;
  final double scoreVolunteer;
  final double scoreVideocall;
  final String? descriptionComment;

  ReviewModel({
    required this.idVideocall,
    required this.scoreVolunteer,
    required this.scoreVideocall,
    this.descriptionComment,
  });

  Map<String, dynamic> toJson() {
    return {
      'idVideocall': idVideocall,
      'scoreVolunteer': scoreVolunteer,
      'scoreVideocall': scoreVideocall,
      'descriptionComment': descriptionComment,
    };
  }
}
