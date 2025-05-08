import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../features/auth/application/sign_up_form_controller.dart';
import '../features/auth/data/auth_service.dart';
import '../features/profile/application/user_skills_controller.dart';
import '../features/profile/data/skill_service.dart';
import '../features/auth/domain/user_model.dart';
import '../features/availability/data/availability_service.dart';
import '../features/profile/data/profile_service.dart';
import '../features/profile/domain/profile_model.dart';

final signUpFormControllerProvider =
    StateNotifierProvider<SignUpFormController, Map<String, String>>(
  (ref) => SignUpFormController(ref),
);

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final tempVolunteerProfileProvider =
    StateProvider<Map<String, dynamic>?>((ref) => null);

final profileProvider = StateProvider<User?>((_) => null);

final skillServiceProvider = Provider<SkillService>((ref) {
  return SkillService();
});

final profileServiceProvider = Provider<ProfileService>((ref) {
  return ProfileService(FlutterSecureStorage());
});

final profileFutureProvider = FutureProvider<Profile?>((ref) async {
  final service = ref.read(profileServiceProvider);
  return service.getProfile();
});

final skillsFutureProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final service = ref.read(skillServiceProvider);
  return service.getSkillsByProfileId();
});

final availabilityServiceProvider = Provider((ref) => AvailabilityService());

final availabilityFutureProvider = FutureProvider((ref) async {
  final service = ref.read(availabilityServiceProvider);
  return service.getAvailabilitiesByUser();
});

final userSkillsProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  return ref.read(skillServiceProvider).getSkillsByProfileId();
});

final userSkillsControllerProvider =
    StateNotifierProvider<UserSkillsController, List<Map<String, dynamic>>>(
  (ref) => UserSkillsController(ref),
);
