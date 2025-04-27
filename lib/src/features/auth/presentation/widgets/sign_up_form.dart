import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:helpwave_mobile_app/src/routing/app_router.dart';

import '../../../../common/animations/animated_route.dart';
import '../../application/sign_up_form_controller.dart';

class SignUpForm extends ConsumerStatefulWidget {
  final String title;
  final List<FormFieldData> fields;
  final String nextRoute;
  final String buttonText;

  const SignUpForm({
    super.key,
    required this.title,
    required this.fields,
    required this.nextRoute,
    required this.buttonText,
  });

  @override
  ConsumerState<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends ConsumerState<SignUpForm> {
  final List<TextEditingController> _controllers = [];

  @override
  void initState() {
    super.initState();
    _controllers.addAll(widget.fields.map((_) => TextEditingController()));
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onNextPressed() {
    final signUpFormController =
        ref.read(signUpFormControllerProvider.notifier);

    for (int i = 0; i < widget.fields.length; i++) {
      signUpFormController.updateField(
          widget.fields[i].label, _controllers[i].text);
    }

    print('Datos en Riverpod: ${ref.read(signUpFormControllerProvider)}');

    Navigator.of(context).push(animatedRouteTo(
      context,
      widget.nextRoute,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    ));
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
                      child: TextField(
                        controller: _controllers[index],
                        obscureText: field.obscureText,
                        keyboardType: field.keyboardType,
                        decoration: InputDecoration(
                          labelText: field.label,
                          border: const OutlineInputBorder(),
                        ),
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
