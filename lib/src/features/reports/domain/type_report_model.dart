class TypeReportModel {
  final int id;
  final String description;

  TypeReportModel({
    required this.id,
    required this.description,
  });

  factory TypeReportModel.fromJson(Map<String, dynamic> json) {
    return TypeReportModel(
      id: json['idTypeReport'],
      description: json['typeDesc'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idTypeReport': id,
      'typeDesc': description,
    };
  }
}
