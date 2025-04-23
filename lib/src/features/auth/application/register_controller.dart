import 'package:flutter_riverpod/flutter_riverpod.dart';

enum UserType { volunteer, requester }

class RegistrationData {
  final String? name;
  final String? email;
  final String? password;
  final UserType? userType;

  RegistrationData({this.name, this.email, this.password, this.userType});

  RegistrationData copyWith({
    String? name,
    String? email,
    String? password,
    UserType? userType,
  }) {
    return RegistrationData(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      userType: userType ?? this.userType,
    );
  }
}

class RegistrationController extends StateNotifier<RegistrationData> {
  RegistrationController() : super(RegistrationData());

  void updateUserType(UserType type) {
    state = state.copyWith(userType: type);
  }

  // Puedes agregar más métodos como updateEmail, updateName, etc.
}

final registrationProvider =
    StateNotifierProvider<RegistrationController, RegistrationData>((ref) {
  return RegistrationController();
});
