class LanguageProfileModel {
  final int idLanguageProfile;
  final int idProfile;
  final int idLanguage;

  LanguageProfileModel({
    required this.idLanguageProfile,
    required this.idProfile,
    required this.idLanguage,
  });

  factory LanguageProfileModel.fromJson(Map<String, dynamic> json) {
    return LanguageProfileModel(
      idLanguageProfile: json['idLanguageProfile'],
      idProfile: json['idProfile'],
      idLanguage: json['idLanguage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idLanguageProfile': idLanguageProfile,
      'idProfile': idProfile,
      'idLanguage': idLanguage,
    };
  }
}
