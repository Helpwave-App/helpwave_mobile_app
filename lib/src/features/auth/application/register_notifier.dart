import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterState {
  final bool isLoading;
  final bool isSuccess;
  final String errorMessage;

  RegisterState({
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage = '',
  });

  RegisterState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
  }) {
    return RegisterState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class RegisterNotifier extends StateNotifier<RegisterState> {
  RegisterNotifier() : super(RegisterState());

  Future<void> registerUser(String name, String email, String password,
      String confirmPassword) async {
    state = state.copyWith(isLoading: true, errorMessage: '', isSuccess: false);

    if (password != confirmPassword) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Las contraseñas no coinciden',
      );
      return;
    }

    try {
      // Verificar si el correo ya está registrado
      //final checkUrl = Uri.parse('http://localhost:3000/users?email=$email');
      final checkUrl = Uri.parse('http://10.0.2.2:3000/users?email=$email');
      final checkResponse = await http.get(checkUrl);

      if (checkResponse.statusCode == 200) {
        final List existingUsers = json.decode(checkResponse.body);

        if (existingUsers.isNotEmpty) {
          // Si hay usuarios con ese correo, mostrar un mensaje de error
          state = state.copyWith(
            isLoading: false,
            errorMessage: 'El correo ya está registrado',
          );
          return;
        }
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Error al verificar el correo',
        );
        return;
      }

      final newUser = {
        'name': name,
        'email': email,
        'password': password,
      };

      // Registrar el nuevo usuario
      final registerUrl = Uri.parse('http://10.0.2.2:3000/users');
      final response = await http.post(
        registerUrl,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(newUser),
      );

      if (response.statusCode == 201) {
        state = state.copyWith(isLoading: false, isSuccess: true);
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Error al registrar',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error de conexión',
      );
    }
  }
}

final registerProvider =
    StateNotifierProvider<RegisterNotifier, RegisterState>((ref) {
  return RegisterNotifier();
});
