import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../common/utils/constants/providers.dart';
import '../../../../localization/codegen_loader.g.dart';

class SignUpFormController extends StateNotifier<Map<String, String>> {
  final Ref _ref;

  SignUpFormController(this._ref) : super({});

  Map<String, String> get _translationKeys => {
        'username': tr(LocaleKeys.auth_signUpForm_fields_username),
        'password': tr(LocaleKeys.auth_signUpForm_fields_password),
        'firstName': tr(LocaleKeys.auth_signUpForm_fields_firstName),
        'lastName': tr(LocaleKeys.auth_signUpForm_fields_lastName),
        'email': tr(LocaleKeys.auth_signUpForm_fields_email),
        'phoneNumber': tr(LocaleKeys.auth_signUpForm_fields_phoneNumber),
      };

  String? _getFieldValue(String key) {
    final translatedKey = _translationKeys[key];
    final value = translatedKey != null ? state[translatedKey]?.trim() : null;
    print('🔍 Buscando campo: $key -> $translatedKey = $value');
    return value;
  }

  Future<Map<String, dynamic>?> submit(String userType) async {
    final authService = _ref.read(authServiceProvider);

    print('🔍 Estado completo antes de procesar: $state');
    print('🔍 Translation keys: $_translationKeys');

    final username = _getFieldValue('username') ?? '';

    final exists = await authService.checkUsername(username);
    if (exists) {
      return {'error': 'El nombre de usuario ya está en uso'};
    }

    final payload = {
      "username": username,
      "password": _getFieldValue('password'),
      "state": true,
      "idRole": userType == "volunteer" ? 1 : 2,
      "profile": {
        "name": _getFieldValue('firstName'),
        "lastName": _getFieldValue('lastName'),
        "email": _getFieldValue('email') ?? "",
        "phoneNumber": _getFieldValue('phoneNumber') ?? "",
        "scoreProfile": 0.0,
        "idLevel": userType == "volunteer" ? 1 : 0,
      }
    };

    print('📝 Valores extraídos:');
    print('  - username: ${_getFieldValue('username')}');
    print('  - password: ${_getFieldValue('password')}');
    print('  - firstName: ${_getFieldValue('firstName')}');
    print('  - lastName: ${_getFieldValue('lastName')}');
    print('  - email: ${_getFieldValue('email')}');
    print('  - phoneNumber: ${_getFieldValue('phoneNumber')}');

    if (payload["password"] == null ||
        (payload["password"] as String).isEmpty) {
      return {'error': 'La contraseña no puede estar vacía'};
    }

    final profileData = payload["profile"] as Map<String, dynamic>;

    for (final field in ["name", "lastName"]) {
      if (profileData[field] == null ||
          (profileData[field] as String).isEmpty) {
        return {'error': 'El campo $field no puede estar vacío'};
      }
    }

    if (userType == "volunteer") {
      if (profileData["email"] == null ||
          (profileData["email"] as String).isEmpty) {
        return {'error': 'El email es requerido para voluntarios'};
      }
    } else {
      if (profileData["phoneNumber"] == null ||
          (profileData["phoneNumber"] as String).isEmpty) {
        return {'error': 'El teléfono es requerido para solicitantes'};
      }
    }

    print('📝 Payload Debug:');
    print('  - Username: ${payload["username"]}');
    print('  - Password: ${payload["password"]}');
    print('  - Profile: ${payload["profile"]}');
    print('  - State actual del controller: $state');

    final response = await authService.registerUser(payload);

    if (response == null || !response.containsKey('idProfile')) {
      return {'error': 'Ocurrió un error al registrar el usuario'};
    }

    if (userType == "volunteer") {
      _ref.read(tempVolunteerProfileProvider.notifier).state = {
        "username": username,
        "profile": payload["profile"],
      };
    }

    return {
      'idProfile': response['idProfile'],
      'message': response['message'],
    };
  }

  void updateField(String fieldName, String value) {
    print('🔍 Debug updateField:');
    print('  - fieldName type: ${fieldName.runtimeType}');
    print('  - fieldName value: "$fieldName"');
    print('  - value type: ${value.runtimeType}');
    print('  - value: "$value"');

    try {
      state = {
        ...state,
        fieldName: value,
      };
    } catch (e) {
      print('❌ Error en updateField: $e');
      print('❌ Estado actual: $state');
    }

    print('📊 Estado después de actualizar: $state');
  }

  void clearForm() {
    state = {};
  }
}
