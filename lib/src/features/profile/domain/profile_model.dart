class Profile {
  final int id;
  final String firtsName;
  final String lastName;
  final String email;
  final String phone;
  final DateTime? birthday;
  final String photoUrl;
  final double scoreProfile;
  final int level;

  Profile({
    required this.id,
    required this.firtsName,
    required this.lastName,
    required this.email,
    required this.phone,
    this.birthday,
    this.photoUrl = '',
    this.scoreProfile = 0.0,
    this.level = 0,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] != null ? int.tryParse(json['id'].toString()) ?? 0 : 0,
      firtsName: json['name']?.toString() ?? '',
      lastName: json['lastName']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phoneNumber']?.toString() ?? '',
      birthday: json['birthDate'] != null
          ? DateTime.tryParse(json['birthDate'].toString())
          : null,
      photoUrl: json['photoUrl']?.toString() ?? '',
      scoreProfile: (json['scoreProfile'] as num?)?.toDouble() ?? 0.0,
      level: (json['idLevel'] as int?) ?? 0,
    );
  }
}
