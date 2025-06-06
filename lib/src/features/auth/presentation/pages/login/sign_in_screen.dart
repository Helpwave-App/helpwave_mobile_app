import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../common/animations/animated_route.dart';
import '../../../../../common/utils/constants/providers.dart';
import '../../../../../routing/app_router.dart';
import '../../../data/auth_service.dart';
import '../../../domain/login_request_model.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final request = LoginRequest(
      username: _usernameController.text.trim(),
      password: _passwordController.text.trim(),
    );

    try {
      await AuthService().login(request);

      ref.invalidate(profileFutureProvider);

      if (!mounted) return;

      Navigator.of(context).pushReplacementNamed(AppRouter.loadingRoute);
    } catch (e) {
      final errorMessage = e.toString().contains('401')
          ? 'auth.signIn.invalidCredentials'.tr()
          : 'auth.signIn.incorrectCredentials'.tr();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: theme.secondary,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 80),
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
            Text('HelpWave',
                style: TextStyle(
                    color: theme.surface,
                    fontSize: 24,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: theme.surface,
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('auth.signIn.title'.tr(),
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _usernameController,
                            enabled: !_isLoading,
                            decoration: InputDecoration(
                                labelText: 'auth.signIn.username'.tr(),
                                border: const OutlineInputBorder()),
                            validator: (value) =>
                                value == null || value.trim().isEmpty
                                    ? 'auth.signIn.usernameRequired'.tr()
                                    : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _passwordController,
                            enabled: !_isLoading,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              labelText: 'auth.signIn.password'.tr(),
                              border: const OutlineInputBorder(),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: _isLoading
                                    ? null
                                    : () {
                                        setState(() {
                                          _obscurePassword = !_obscurePassword;
                                        });
                                      },
                              ),
                            ),
                            validator: (value) =>
                                value == null || value.length < 6
                                    ? 'auth.signIn.passwordMinLength'.tr()
                                    : null,
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _isLoading ? null : _submit,
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(50),
                              backgroundColor: theme.tertiary,
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : Text('auth.signIn.signInButton'.tr()),
                          ),
                          const SizedBox(height: 16),
                          Center(
                            child: TextButton(
                              onPressed: _isLoading ? null : () {},
                              child: Text('auth.signIn.forgotPassword'.tr(),
                                  style: TextStyle(
                                    color: _isLoading
                                        ? Colors.grey
                                        : theme.tertiary,
                                  )),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('auth.signIn.noAccount'.tr(),
                                    style: TextStyle(color: theme.onTertiary)),
                                TextButton(
                                  onPressed: _isLoading
                                      ? null
                                      : () {
                                          Navigator.of(context).push(
                                              animatedRouteTo(context,
                                                  AppRouter.userTypeRoute,
                                                  duration: const Duration(
                                                      milliseconds: 200),
                                                  curve: Curves.easeInOut));
                                        },
                                  child: Text('auth.signIn.registerNow'.tr(),
                                      style: TextStyle(
                                        color: _isLoading
                                            ? Colors.grey
                                            : theme.tertiary,
                                      )),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
