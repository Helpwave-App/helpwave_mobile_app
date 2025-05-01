class AvailabilityEntry {
  final String day; // "1", "2", ..., "7"
  final String hourStart; // formato "HH:mm"
  final String hourEnd;

  AvailabilityEntry({
    required this.day,
    required this.hourStart,
    required this.hourEnd,
  });

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'hourStart': hourStart,
      'hourEnd': hourEnd,
    };
  }
}

class AvailabilityPayload {
  final int idProfile;
  final List<Map<String, dynamic>> availabilities;

  AvailabilityPayload({required this.idProfile, required this.availabilities});

  Map<String, dynamic> toJson() {
    return {
      'idProfile': idProfile,
      'availabilities': availabilities,
    };
  }

  factory AvailabilityPayload.fromMap(Map<String, dynamic> map) {
    return AvailabilityPayload(
      idProfile: map['idProfile'] as int,
      availabilities: List<Map<String, String>>.from(map['availabilities']),
    );
  }
}
