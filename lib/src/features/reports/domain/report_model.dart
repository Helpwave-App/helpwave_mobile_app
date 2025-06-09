class ReportModel {
  final int idVideocall;
  final int idProfile;
  final int idTypeReport;
  final String descriptionReport;

  ReportModel({
    required this.idVideocall,
    required this.idProfile,
    required this.idTypeReport,
    required this.descriptionReport,
  });

  Map<String, dynamic> toJson() {
    return {
      'idVideocall': idVideocall,
      'idProfile': idProfile,
      'idTypeReport': idTypeReport,
      'descriptionReport': descriptionReport,
    };
  }
}
