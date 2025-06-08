import 'availability_model.dart';

class AvailabilityPayload {
  final int idProfile;
  final List<Availability> availabilities;

  AvailabilityPayload({required this.idProfile, required this.availabilities});

  Map<String, dynamic> toJson() {
    return {
      'idProfile': idProfile,
      'availabilities': availabilities.map((a) => a.toJson()).toList(),
    };
  }

  factory AvailabilityPayload.fromMap(Map<String, dynamic> map) {
    return AvailabilityPayload(
      idProfile: map['idProfile'] as int,
      availabilities: List<Map<String, dynamic>>.from(map['availabilities'])
          .map((json) => Availability.fromJson(json))
          .toList(),
    );
  }
}
