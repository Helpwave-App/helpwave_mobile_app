class VideocallResponse {
  final String token;
  final String channel;
  final int idVideocall;

  VideocallResponse({
    required this.token,
    required this.channel,
    required this.idVideocall,
  });

  factory VideocallResponse.fromJson(Map<String, dynamic> json) {
    return VideocallResponse(
      token: json['token'],
      channel: json['channel'],
      idVideocall: json['idVideocall'] ?? 0,
    );
  }
}
