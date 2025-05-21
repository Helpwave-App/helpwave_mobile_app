import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../features/auth/application/sign_up_form_controller.dart';
import '../../features/auth/data/auth_service.dart';
import '../../features/availability/application/user_availability_controller.dart';
import '../../features/profile/application/user_info_controller.dart';
import '../../features/profile/application/user_skills_controller.dart';
import '../../features/profile/data/skill_service.dart';
import '../../features/auth/domain/user_model.dart';
import '../../features/availability/data/availability_service.dart';
import '../../features/profile/data/profile_service.dart';
import '../../features/profile/domain/profile_model.dart';
import '../../features/help_response/data/videocall_service.dart';

final secureStorageProvider = Provider((ref) => const FlutterSecureStorage());

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
  return ProfileService(ref.watch(secureStorageProvider));
});

final profileFutureProvider = FutureProvider<Profile?>((ref) async {
  final service = ref.watch(profileServiceProvider);
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

final userAvailabilityControllerProvider = StateNotifierProvider.autoDispose<
    UserAvailabilityController, AsyncValue<Map<String, List<TimeRange>>>>(
  (ref) => UserAvailabilityController(ref),
);

final userInfoControllerProvider =
    StateNotifierProvider<UserInfoController, bool>((ref) {
  return UserInfoController(ref);
});

final userRoleProvider = FutureProvider<String?>((ref) async {
  final authService = ref.read(authServiceProvider);
  return authService.getUserRole();
});

final videocallServiceProvider = Provider<VideocallService>((ref) {
  return VideocallService();
});
