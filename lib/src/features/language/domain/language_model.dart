class LanguageModel {
  final int idLanguage;
  final String nameLanguage;

  LanguageModel({
    required this.idLanguage,
    required this.nameLanguage,
  });

  factory LanguageModel.fromJson(Map<String, dynamic> json) {
    return LanguageModel(
      idLanguage: json['idLanguage'],
      nameLanguage: json['nameLanguage'],
    );
  }

  Map<String, dynamic> toJson() => {
        'idLanguage': idLanguage,
        'nameLanguage': nameLanguage,
      };
}
