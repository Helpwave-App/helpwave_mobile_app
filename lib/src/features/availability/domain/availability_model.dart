class Availability {
  final int? id;
  final int day;
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
      day: int.parse(json['day'].toString()),
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
