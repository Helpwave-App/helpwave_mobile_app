import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../localization/codegen_loader.g.dart';
import '../../../../common/animations/animated_route.dart';
import '../../../../common/utils/constants/providers.dart';
import '../../../../routing/app_router.dart';

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
  int? _selectedLanguageId;

  bool _languageTouched = false;
  bool _languageSubmitAttempted = false;

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
    setState(() {
      _isLoading = true;
      _languageSubmitAttempted = true;
    });

    final signUpFormController =
        ref.read(signUpFormControllerProvider.notifier);

    bool hasError = false;
    for (int i = 0; i < widget.fields.length; i++) {
      final value = _controllers[i].text.trim();
      final fieldLabel = tr(widget.fields[i].translationKey);

      if (value.isEmpty) {
        _errorMessages[i] = tr(LocaleKeys.auth_signUpForm_errors_required);
        hasError = true;
        continue;
      }

      if (widget.fields[i].translationKey ==
              LocaleKeys.auth_signUpForm_fields_firstName ||
          widget.fields[i].translationKey ==
              LocaleKeys.auth_signUpForm_fields_lastName) {
        final cleaned = value.trim();
        if (!RegExp(r'^[A-Za-zÁÉÍÓÚáéíóúÑñ ]+$').hasMatch(cleaned)) {
          _errorMessages[i] = tr(LocaleKeys.auth_signUpForm_errors_onlyLetters);
          hasError = true;
          continue;
        }
      }

      if (widget.fields[i].translationKey ==
          LocaleKeys.auth_signUpForm_fields_phoneNumber) {
        final cleaned = value.trim();
        if (!RegExp(r'^\d{9}$').hasMatch(cleaned)) {
          _errorMessages[i] = tr(LocaleKeys.auth_signUpForm_errors_phoneNumber);
          hasError = true;
          continue;
        }
      }

      if (widget.fields[i].translationKey ==
          LocaleKeys.auth_signUpForm_fields_username) {
        final cleaned = value.trim();
        if (!RegExp(r'^[a-zA-Z0-9_]{6,}$').hasMatch(cleaned)) {
          _errorMessages[i] = tr(LocaleKeys.auth_signUpForm_errors_username);
          hasError = true;
          continue;
        }
      }

      if (widget.fields[i].translationKey ==
          LocaleKeys.auth_signUpForm_fields_password) {
        if (value.length < 6) {
          _errorMessages[i] =
              tr(LocaleKeys.auth_signUpForm_errors_passwordMinLength);
          hasError = true;
          continue;
        }
      }

      _errorMessages[i] = null;
      signUpFormController.updateField(fieldLabel, value);
    }

    if (_selectedLanguageId == null) {
      hasError = true;
    }

    setState(() {});
    if (hasError) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      final result = await signUpFormController.submit(widget.userType);

      if (result == null || result.containsKey('error')) {
        final idx = widget.fields.indexWhere((f) =>
            f.translationKey == LocaleKeys.auth_signUpForm_fields_username);
        if (idx != -1) {
          _errorMessages[idx] = result?['error'] ??
              tr(LocaleKeys.auth_signUpForm_errors_unknownError);
          setState(() {});
        }

        _showError(result?['error']);
        return;
      }

      final idProfile = result['idProfile'];
      if (!mounted) return;

      print('✅ Usuario registrado exitosamente con idProfile: $idProfile');

      final languageProfileService = ref.read(languageProfileServiceProvider);
      await languageProfileService.addLanguageToProfile(
        idLanguage: _selectedLanguageId!,
        idProfile:
            idProfile is int ? idProfile : int.parse(idProfile.toString()),
      );

      print('✅ Idioma agregado exitosamente al perfil');

      final usernameIndex = widget.fields.indexWhere((f) =>
          tr(f.translationKey) ==
          tr(LocaleKeys.auth_signUpForm_fields_username));
      final passwordIndex = widget.fields.indexWhere((f) =>
          tr(f.translationKey) ==
          tr(LocaleKeys.auth_signUpForm_fields_password));

      if (usernameIndex == -1 || passwordIndex == -1) {
        if (!mounted) return;
        _showError(tr(LocaleKeys.auth_signUpForm_errors_internalError));
        return;
      }

      if (!mounted) return;
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
      print('❌ Error detallado durante el registro: $e');
      _showError(tr(LocaleKeys.auth_signUpForm_errors_unexpectedError));
      if (kDebugMode) {
        print('Stack trace: ${e.toString()}');
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
    final languagesAsync = ref.watch(languagesProvider);

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60),
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 180,
                ),
                child: Hero(
                  tag: 'app-logo',
                  child: Image.asset(
                    'lib/src/assets/images/logo-white.png',
                    width: MediaQuery.of(context).size.width * 0.45,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: theme.surface,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(24)),
                ),
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
                        child: TextField(
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
                      );
                    }),
                    languagesAsync.when(
                      data: (languages) {
                        // ignore: deprecated_member_use
                        return DropdownButtonFormField<int>(
                          initialValue: _selectedLanguageId,
                          decoration: InputDecoration(
                            labelText:
                                tr(LocaleKeys.auth_signUpForm_fields_language),
                            border: const OutlineInputBorder(),
                            errorText: (_languageSubmitAttempted ||
                                        _languageTouched) &&
                                    _selectedLanguageId == null
                                ? tr('Por favor selecciona un idioma')
                                : null,
                          ),
                          items: languages
                              .map(
                                (lang) => DropdownMenuItem<int>(
                                  value: lang.idLanguage,
                                  child: Text(lang.nameLanguage),
                                ),
                              )
                              .toList(),
                          onChanged: _isLoading
                              ? null
                              : (int? val) {
                                  setState(() {
                                    _selectedLanguageId = val;
                                    _languageTouched = true;
                                  });
                                },
                        );
                      },
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (_, __) => Text(
                        tr(LocaleKeys.auth_signUpForm_errors_loading_languages),
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
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
                          Text(tr(LocaleKeys.auth_signUpForm_haveAccount),
                              style: TextStyle(color: theme.onTertiary)),
                          TextButton(
                            onPressed: _isLoading
                                ? null
                                : () {
                                    Navigator.of(context).push(animatedRouteTo(
                                      context,
                                      AppRouter.loginRoute,
                                      duration:
                                          const Duration(milliseconds: 200),
                                      curve: Curves.easeInOut,
                                    ));
                                  },
                            child: Text(
                              tr(LocaleKeys.auth_signUpForm_signIn),
                              style: TextStyle(
                                color:
                                    _isLoading ? Colors.grey : theme.tertiary,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FormFieldData {
  final String labelKey;
  final String translationKey;
  final bool obscureText;
  final TextInputType keyboardType;

  const FormFieldData({
    required this.labelKey,
    required this.translationKey,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
  });
}
