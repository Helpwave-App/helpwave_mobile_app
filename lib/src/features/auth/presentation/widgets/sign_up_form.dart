import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:helpwave_mobile_app/src/routing/app_router.dart';

import '../../../../common/animations/animated_route.dart';
import '../../../../utils/providers.dart';

class SignUpForm extends ConsumerStatefulWidget {
  final String title;
  final List<FormFieldData> fields;
  final String nextRoute;
  final String buttonText;
  final String userType;

  const SignUpForm(
      {super.key,
      required this.title,
      required this.fields,
      required this.nextRoute,
      required this.buttonText,
      required this.userType});

  @override
  ConsumerState<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends ConsumerState<SignUpForm> {
  final List<TextEditingController> _controllers = [];
  List<String?> _errorMessages = [];
  late List<bool> _obscureTextStates;

  @override
  void initState() {
    super.initState();
    _controllers.addAll(widget.fields.map((_) => TextEditingController()));
    _errorMessages = List<String?>.filled(widget.fields.length, null);
    _obscureTextStates = widget.fields.map((f) => f.obscureText).toList();
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _onNextPressed() async {
    final signUpFormController =
        ref.read(signUpFormControllerProvider.notifier);

    bool hasError = false;
    for (int i = 0; i < widget.fields.length; i++) {
      final value = _controllers[i].text.trim();
      final field = widget.fields[i].label;

      if (value.isEmpty) {
        _errorMessages[i] = 'Este campo es obligatorio';
        hasError = true;
        continue;
      }

      if (field == "Número de teléfono") {
        if (!RegExp(r'^\d{9}$').hasMatch(value)) {
          _errorMessages[i] = 'Ingresa un número de 9 dígitos válido';
          hasError = true;
          continue;
        }
      }

      if (field == "Nombre de usuario") {
        if (!RegExp(r'^[a-zA-Z0-9_]{6,}$').hasMatch(value)) {
          _errorMessages[i] = 'Usa al menos 6 caracteres alfanuméricos';
          hasError = true;
          continue;
        }
      }

      if (field == "Contraseña") {
        if (value.length < 6) {
          _errorMessages[i] = 'La contraseña debe tener al menos 6 caracteres';
          hasError = true;
          continue;
        }
      }

      _errorMessages[i] = null;
      signUpFormController.updateField(field, value);
    }

    setState(() {});
    if (hasError) return;

    try {
      final result = await ref
          .read(signUpFormControllerProvider.notifier)
          .submit(widget.userType);

      if (result == null || result.containsKey('error')) {
        final idx =
            widget.fields.indexWhere((f) => f.label == 'Nombre de usuario');
        if (idx != -1) {
          _errorMessages[idx] = result?['error'] ?? 'Error desconocido';
          setState(() {});
        }
        return;
      }

      final idProfile = result['idProfile'];
      if (kDebugMode) {
        print('idProfile obtenido después del registro: $idProfile');
      }
      if (!mounted) return;

      final usernameIndex =
          widget.fields.indexWhere((f) => f.label == 'Nombre de usuario');
      final passwordIndex =
          widget.fields.indexWhere((f) => f.label == 'Contraseña');

      if (usernameIndex == -1 || passwordIndex == -1) {
        _showError('Error interno: faltan campos de usuario o contraseña.');
        return;
      }

      Navigator.of(context).pushReplacement(animatedRouteTo(
        context,
        widget.nextRoute,
        args: {
          'idProfile': idProfile,
          'username': _controllers[usernameIndex].text.trim(),
          'password': _controllers[passwordIndex].text.trim(),
        },
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      ));
    } catch (e) {
      _showError('Ocurrió un error inesperado. Intenta de nuevo.');
      if (kDebugMode) {
        print('Error en submit(): $e');
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Column(
      children: [
        const SizedBox(height: 60),
        Hero(
          tag: 'app-logo',
          child: CircleAvatar(
            radius: 40,
            backgroundColor: theme.surface,
            child: Icon(
              Icons.account_balance_wallet,
              color: theme.tertiary,
              size: 40,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'HelpWave',
          style: TextStyle(
            color: theme.surface,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.surface,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.title,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  ...List.generate(widget.fields.length, (index) {
                    final field = widget.fields[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: _controllers[index],
                            obscureText: field.obscureText,
                            keyboardType: field.keyboardType,
                            decoration: InputDecoration(
                              labelText: field.label,
                              border: const OutlineInputBorder(),
                              errorText: _errorMessages[index],
                              suffixIcon: field.obscureText
                                  ? IconButton(
                                      icon: Icon(
                                        _obscureTextStates[index]
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscureTextStates[index] =
                                              !_obscureTextStates[index];
                                        });
                                      },
                                    )
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _onNextPressed,
                    child: Text(widget.buttonText),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("¿Ya tienes una cuenta?",
                            style: TextStyle(color: theme.onTertiary)),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(animatedRouteTo(
                                context, AppRouter.loginRoute,
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.easeInOut));
                          },
                          child: Text("Inicia sesión",
                              style: TextStyle(color: theme.tertiary)),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class FormFieldData {
  final String label;
  final bool obscureText;
  final TextInputType keyboardType;

  const FormFieldData({
    required this.label,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
  });
}
