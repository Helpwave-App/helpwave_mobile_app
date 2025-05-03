import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utils/providers.dart';

class SignUpFormController extends StateNotifier<Map<String, String>> {
  final Ref _ref;

  SignUpFormController(this._ref) : super({});

  Future<Map<String, dynamic>?> submit(String userType) async {
    final authService = _ref.read(authServiceProvider);
    final username = state['Nombre de usuario']?.trim() ?? '';

    final exists = await authService.checkUsername(username);
    if (exists) {
      return {'error': 'El nombre de usuario ya está en uso'};
    }

    final payload = {
      "username": username,
      "password": state["Contraseña"]?.trim(),
      "state": true,
      "idRole": userType == "volunteer" ? 1 : 2, // 1: volunteer, 2: requester
      "profile": {
        "name": state["Nombre"]?.trim(),
        "lastName": state["Apellido"]?.trim(),
        "scoreProfile": 0.0,
        "idLevel": userType == "volunteer" ? 1 : 0,
      }
    };

    final response = await authService.registerUser(payload);

    if (userType == "volunteer") {
      _ref.read(tempVolunteerProfileProvider.notifier).state = {
        "username": username,
        "profile": payload["profile"],
      };
    }

    return {
      'idProfile': response?['idProfile'],
      'message': response?['message'],
    };
  }

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
