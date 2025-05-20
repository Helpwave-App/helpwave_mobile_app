import 'empairing_model.dart';

class HelpRequest {
  final Empairing empairing;
  final String requesterName;
  final String skillName;

  HelpRequest({
    required this.empairing,
    required this.requesterName,
    required this.skillName,
  });
}
