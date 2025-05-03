class Availability {
  final int id;
  final String day;
  final String hourStart;
  final String hourEnd;

  Availability({
    required this.id,
    required this.day,
    required this.hourStart,
    required this.hourEnd,
  });

  factory Availability.fromJson(Map<String, dynamic> json) {
    return Availability(
      id: json['idAvailability'],
      day: json['day'],
      hourStart: json['hourStart'],
      hourEnd: json['hourEnd'],
    );
  }
}
