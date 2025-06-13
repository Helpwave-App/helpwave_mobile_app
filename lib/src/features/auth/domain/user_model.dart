class User {
  final int id;
  final String username;
  final String role;

  User({
    required this.id,
    required this.username,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['idProfile'],
        username: json['username'],
        role: json['role'],
      );
}
