import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:helpwave_mobile_app/src/routing/app_router.dart';

import '../../../../common/animations/animated_route.dart';
import '../../../../common/utils/constants/providers.dart';

class SignUpForm extends ConsumerStatefulWidget {
  final String titleKey;
  final List<FormFieldData> fields;
  final String nextRoute;
  final String buttonTextKey;
  final String userType;

  const SignUpForm({
    super.key,
    required this.titleKey,
    required this.fields,
    required this.nextRoute,
    required this.buttonTextKey,
    required this.userType,
  });

  @override
  ConsumerState<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends ConsumerState<SignUpForm> {
  final List<TextEditingController> _controllers = [];
  List<String?> _errorMessages = [];
  late List<bool> _obscureTextStates;
  bool _isLoading = false;

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
    setState(() => _isLoading = true);
    final signUpFormController =
        ref.read(signUpFormControllerProvider.notifier);

    bool hasError = false;
    for (int i = 0; i < widget.fields.length; i++) {
      final value = _controllers[i].text.trim();
      final fieldLabel = tr(widget.fields[i].translationKey);

      if (value.isEmpty) {
        _errorMessages[i] = tr('auth.signUpForm.errors.requiredField');
        hasError = true;
        continue;
      }

      if (widget.fields[i].translationKey ==
              'auth.signUpForm.fields.firstName' ||
          widget.fields[i].translationKey ==
              'auth.signUpForm.fields.lastName') {
        final cleaned = value.trim();
        if (!RegExp(r'^[A-Za-zÁÉÍÓÚáéíóúÑñ ]+$').hasMatch(cleaned)) {
          _errorMessages[i] = tr('auth.signUpForm.errors.invalidName');
          hasError = true;
          continue;
        }
      }

      if (widget.fields[i].translationKey ==
          'auth.signUpForm.fields.phoneNumber') {
        final cleaned = value.trim();
        if (!RegExp(r'^\d{9}$').hasMatch(cleaned)) {
          _errorMessages[i] = tr('auth.signUpForm.errors.invalidPhone');
          hasError = true;
          continue;
        }
      }

      if (widget.fields[i].translationKey ==
          'auth.signUpForm.fields.username') {
        final cleaned = value.trim();
        if (!RegExp(r'^[a-zA-Z0-9_]{6,}$').hasMatch(cleaned)) {
          _errorMessages[i] = tr('auth.signUpForm.errors.invalidUsername');
          hasError = true;
          continue;
        }
      }

      if (widget.fields[i].translationKey ==
          'auth.signUpForm.fields.password') {
        if (value.length < 6) {
          _errorMessages[i] = tr('auth.signUpForm.errors.passwordLength');
          hasError = true;
          continue;
        }
      }

      _errorMessages[i] = null;
      signUpFormController.updateField(fieldLabel, value);
    }

    setState(() {});
    if (hasError) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      final result = await ref
          .read(signUpFormControllerProvider.notifier)
          .submit(widget.userType);

      if (result == null || result.containsKey('error')) {
        final idx = widget.fields.indexWhere(
            (f) => f.translationKey == 'auth.signUpForm.fields.username');
        if (idx != -1) {
          _errorMessages[idx] =
              result?['error'] ?? tr('auth.signUpForm.errors.unknown');
          setState(() {});
        }
        return;
      }

      final idProfile = result['idProfile'];
      if (kDebugMode) {
        print('idProfile obtenido después del registro: $idProfile');
      }
      if (!mounted) return;

      final usernameIndex = widget.fields.indexWhere(
          (f) => f.translationKey == 'auth.signUpForm.fields.username');
      final passwordIndex = widget.fields.indexWhere(
          (f) => f.translationKey == 'auth.signUpForm.fields.password');

      if (usernameIndex == -1 || passwordIndex == -1) {
        _showError(tr('auth.signUpForm.errors.internalError'));
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
      _showError(tr('auth.signUpForm.errors.unexpected'));
      if (kDebugMode) {
        print('Error en submit(): $e');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
                  Text(
                    tr(widget.titleKey),
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
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
                            obscureText: _obscureTextStates[index],
                            keyboardType: field.keyboardType,
                            enabled: !_isLoading,
                            decoration: InputDecoration(
                              labelText: tr(field.translationKey),
                              border: const OutlineInputBorder(),
                              errorText: _errorMessages[index],
                              suffixIcon: field.obscureText
                                  ? IconButton(
                                      icon: Icon(
                                        _obscureTextStates[index]
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                      ),
                                      onPressed: _isLoading
                                          ? null
                                          : () {
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
                    onPressed: _isLoading ? null : _onNextPressed,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      backgroundColor: theme.tertiary,
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(tr(widget.buttonTextKey)),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(tr('auth.signUpForm.haveAccount'),
                            style: TextStyle(color: theme.onTertiary)),
                        TextButton(
                          onPressed: _isLoading
                              ? null
                              : () {
                                  Navigator.of(context).push(animatedRouteTo(
                                    context,
                                    AppRouter.loginRoute,
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.easeInOut,
                                  ));
                                },
                          child: Text(
                            tr('auth.signUpForm.login'),
                            style: TextStyle(
                              color: _isLoading ? Colors.grey : theme.tertiary,
                            ),
                          ),
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
  final String translationKey;
  final bool obscureText;
  final TextInputType keyboardType;

  const FormFieldData({
    required this.label,
    required this.translationKey,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
  });
}
