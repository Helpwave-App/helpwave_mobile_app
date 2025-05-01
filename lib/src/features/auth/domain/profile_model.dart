class Profile {
  final int id;
  final String username;
  final String role;

  Profile({
    required this.id,
    required this.username,
    required this.role,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        id: json['idProfile'],
        username: json['username'],
        role: json['role'],
      );
}
