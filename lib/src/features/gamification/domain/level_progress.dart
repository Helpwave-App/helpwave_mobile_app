class LevelProgressModel {
  final int assistances;
  final int missingAssistances;
  final double scoreProfile;
  final String currentLevel;
  final String currentLevelPhotoUrl;
  final String nextLevel;
  final String nextLevelPhotoUrl;

  LevelProgressModel(
      {required this.assistances,
      required this.missingAssistances,
      required this.scoreProfile,
      required this.currentLevel,
      required this.currentLevelPhotoUrl,
      required this.nextLevel,
      required this.nextLevelPhotoUrl});

  factory LevelProgressModel.fromJson(Map<String, dynamic> json) {
    return LevelProgressModel(
      assistances: json['assistances'],
      missingAssistances: json['missingAssistances'],
      scoreProfile: (json['scoreProfile'] as num).toDouble(),
      currentLevel: json['currentLevel'],
      currentLevelPhotoUrl: json['currentLevelPhotoUrl'] ?? '',
      nextLevel: json['nextLevel'],
      nextLevelPhotoUrl: json['nextLevelPhotoUrl'] ?? '',
    );
  }
}
