class Request {
  final int idRequest;
  final DateTime date;
  final String skill;
  final String volunteerName;
  final String requesterName;

  Request({
    required this.idRequest,
    required this.date,
    required this.skill,
    required this.volunteerName,
    required this.requesterName,
  });

  factory Request.fromJson(Map<String, dynamic> json) {
    return Request(
      idRequest: json['idRequest'],
      date: DateTime.parse(json['date']),
      skill: json['skill'],
      volunteerName: json['volunteerName'],
      requesterName: json['requesterName'],
    );
  }
}
