import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../features/auth/application/sign_up_form_controller.dart';
import '../../../features/auth/data/auth_service.dart';
import '../../../features/auth/domain/user_model.dart';
import '../../../features/gamification/application/level_cache_controller.dart';
import '../../../features/availability/application/user_availability_controller.dart';
import '../../../features/language/data/language_profile_service.dart';
import '../../../features/language/data/language_service.dart';
import '../../../features/language/domain/language_model.dart';
import '../../../features/profile/application/user_info_controller.dart';
import '../../../features/reports/data/report_service.dart';
import '../../../features/reports/data/type_report_service.dart';
import '../../../features/reports/domain/report_model.dart';
import '../../../features/reports/domain/type_report_model.dart';
import '../../../features/skills/application/user_skills_controller.dart';
import '../../../features/availability/data/availability_service.dart';
import '../../../features/profile/data/profile_service.dart';
import '../../../features/skills/data/skill_service.dart';
import '../../../features/profile/domain/profile_model.dart';
import '../../../features/gamification/application/level_controller.dart';
import '../../../features/gamification/data/level_service.dart';
import '../../../features/gamification/domain/level_model.dart';
import '../../../features/videocalls/data/videocall_service.dart';
import '../../../features/reviews/application/review_controller.dart';
import '../../../features/gamification/domain/level_progress.dart';

final secureStorageProvider = Provider((ref) => const FlutterSecureStorage());

final signUpFormControllerProvider =
    StateNotifierProvider<SignUpFormController, Map<String, String>>(
  (ref) => SignUpFormController(ref),
);

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final tempVolunteerProfileProvider =
    StateProvider<Map<String, dynamic>?>((ref) => null);

final profileProvider = StateProvider<User?>((_) => null);

final themeModeProvider =
    StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.system);

  void setThemeMode(ThemeMode mode) {
    state = mode;
  }
}

final languageProfileServiceProvider = Provider<LanguageProfileService>((ref) {
  return LanguageProfileService();
});

final languageServiceProvider =
    Provider<LanguageService>((ref) => LanguageService());

final languagesProvider = FutureProvider<List<LanguageModel>>((ref) async {
  final service = ref.watch(languageServiceProvider);
  return await service.fetchLanguages();
});

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

final reviewControllerProvider =
    ChangeNotifierProvider.autoDispose<ReviewController>((ref) {
  return ReviewController();
});

final levelServiceProvider = Provider<LevelService>((ref) {
  return LevelService();
});

final levelProgressControllerProvider =
    AsyncNotifierProvider<LevelProgressController, LevelProgressModel>(
  () => LevelProgressController(),
);

final levelFutureProvider =
    FutureProvider.family<Level, int>((ref, idLevel) async {
  final service = ref.read(levelServiceProvider);
  return service.fetchLevel(idLevel);
});

final levelCacheControllerProvider =
    StateNotifierProvider<LevelCacheController, Map<int, Level>>(
  (ref) => LevelCacheController(ref.read(levelServiceProvider)),
);

final typeReportServiceProvider = Provider((ref) => TypeReportService());
final reportServiceProvider = Provider((ref) => ReportService());

final typeReportsProvider = FutureProvider<List<TypeReportModel>>((ref) async {
  final service = ref.read(typeReportServiceProvider);
  return await service.fetchTypeReports();
});

final reportSubmissionProvider =
    FutureProvider.family.autoDispose<void, ReportModel>((ref, report) async {
  final service = ref.read(reportServiceProvider);
  return await service.createReport(report);
});
