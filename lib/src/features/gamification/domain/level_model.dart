class Level {
  final int idLevel;
  final String nameLevel;
  final int minRequest;
  final int maxRequest;
  final String photoUrl;

  const Level({
    required this.idLevel,
    required this.nameLevel,
    required this.minRequest,
    required this.maxRequest,
    required this.photoUrl,
  });

  factory Level.fromJson(Map<String, dynamic> json) {
    return Level(
      idLevel: json['idLevel'],
      nameLevel: json['nameLevel'],
      minRequest: json['minRequest'],
      maxRequest: json['maxRequest'],
      photoUrl: json['photoUrl'],
    );
  }
}
