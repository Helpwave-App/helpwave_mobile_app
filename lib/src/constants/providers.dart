import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/auth/application/sign_up_form_controller.dart';
import '../features/auth/data/auth_service.dart';
import '../features/auth/data/skill_service.dart';
import '../features/auth/domain/profile_model.dart';

final signUpFormControllerProvider =
    StateNotifierProvider<SignUpFormController, Map<String, String>>(
  (ref) => SignUpFormController(ref),
);

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final tempVolunteerProfileProvider =
    StateProvider<Map<String, dynamic>?>((ref) => null);

final profileProvider = StateProvider<Profile?>((_) => null);

final skillServiceProvider = Provider<SkillService>((ref) {
  return SkillService();
});
