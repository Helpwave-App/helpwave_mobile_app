class VideocallResponse {
  final String token;
  final String channel;

  VideocallResponse({
    required this.token,
    required this.channel,
  });

  factory VideocallResponse.fromJson(Map<String, dynamic> json) {
    return VideocallResponse(
      token: json['token'],
      channel: json['channel'],
    );
  }
}
