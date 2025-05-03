class AuthResponse {
  final String token;
  final String role;
  final int idUser;

  AuthResponse({required this.token, required this.role, required this.idUser});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['jwttoken'],
      idUser: json['idUser'],
      role: json['role'],
    );
  }
}
