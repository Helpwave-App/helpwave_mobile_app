class Availability {
  final int? id;
  final String day;
  final String hourStart;
  final String hourEnd;

  Availability({
    this.id,
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

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'idAvailability': id,
      'day': day,
      'hourStart': hourStart,
      'hourEnd': hourEnd,
    };
  }
}
