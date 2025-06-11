class ReportModel {
  final int idVideocall;
  final int idTypeReport;
  final String descriptionReport;

  ReportModel({
    required this.idVideocall,
    required this.idTypeReport,
    required this.descriptionReport,
  });

  Map<String, dynamic> toJson(int idProfile) {
    return {
      'idVideocall': idVideocall,
      'idTypeReport': idTypeReport,
      'idProfile': idProfile,
      'descriptionReport': descriptionReport,
    };
  }
}
