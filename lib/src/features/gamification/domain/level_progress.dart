class LevelProgressModel {
  final int assistances;
  final String currentLevel;
  final int missingAssistances;
  final String nextLevel;
  final double scoreProfile;

  LevelProgressModel({
    required this.assistances,
    required this.currentLevel,
    required this.missingAssistances,
    required this.nextLevel,
    required this.scoreProfile,
  });

  factory LevelProgressModel.fromJson(Map<String, dynamic> json) {
    return LevelProgressModel(
      assistances: json['assistances'],
      currentLevel: json['currentLevel'],
      missingAssistances: json['missingAssistances'],
      nextLevel: json['nextLevel'],
      scoreProfile: (json['scoreProfile'] as num).toDouble(),
    );
  }
}
