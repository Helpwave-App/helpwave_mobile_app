import 'package:flutter_riverpod/flutter_riverpod.dart';

final signUpFormControllerProvider =
    StateNotifierProvider<SignUpFormController, Map<String, String>>(
  (ref) => SignUpFormController(),
);

class SignUpFormController extends StateNotifier<Map<String, String>> {
  SignUpFormController() : super({});

  void updateField(String fieldName, String value) {
    state = {
      ...state,
      fieldName: value,
    };
  }

  void clearForm() {
    state = {};
  }
}
