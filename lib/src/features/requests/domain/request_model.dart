class Request {
  final int idRequest;
  final int idProfile;
  final int idSkill;
  final bool stateRequest;
  final String tokenDevice;
  final DateTime dateRequest;
  final String duration;
  final String skillDescription;

  Request({
    required this.idRequest,
    required this.idProfile,
    required this.idSkill,
    required this.stateRequest,
    required this.tokenDevice,
    required this.dateRequest,
    required this.duration,
    required this.skillDescription,
  });

  factory Request.fromJson(Map<String, dynamic> json) {
    return Request(
      idRequest: json['idRequest'],
      idProfile: json['idProfile'],
      idSkill: json['idSkill'],
      stateRequest: json['stateRequest'],
      tokenDevice: json['tokenDevice'],
      dateRequest: DateTime.parse(json['dateRequest']),
      duration: json['duration'],
      skillDescription: json['skillDescription'],
    );
  }
}
