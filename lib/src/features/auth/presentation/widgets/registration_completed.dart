import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../common/pages/loading_screen.dart';
import '../../../../common/utils/constants/providers.dart';
import '../../../../common/utils/constants/secure_storage.dart';
import '../../../../routing/app_router.dart';
import '../../data/auth_service.dart';
import '../../domain/login_request_model.dart';

class RegistrationCompletedWidget extends ConsumerStatefulWidget {
  final String title;
  final String message;
  final String? subtitle;
  final IconData icon;
  final String userType;
  final String? username;
  final String? password;

  const RegistrationCompletedWidget({
    super.key,
    required this.title,
    required this.message,
    required this.userType,
    this.username,
    this.password,
    this.subtitle,
    this.icon = Icons.volunteer_activism,
  });

  @override
  ConsumerState<RegistrationCompletedWidget> createState() =>
      _RegistrationCompletedWidgetState();
}

class _RegistrationCompletedWidgetState
    extends ConsumerState<RegistrationCompletedWidget> {
  bool _isLoading = false;

  Future<void> _onNextPressed() async {
    if (widget.username == null || widget.password == null) return;

    final scaffoldMessenger = ScaffoldMessenger.of(context);

    setState(() {
      _isLoading = true;
    });

    try {
      final request = LoginRequest(
        username: widget.username!.trim(),
        password: widget.password!.trim(),
      );

      final response = await AuthService().login(request);
      await SecureStorage.saveToken(response.token);
      await SecureStorage.saveIdUser(response.idUser);
      await SecureStorage.saveRole(response.role);

      ref.invalidate(profileFutureProvider);

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoadingScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
              content: Text('auth.registrationCompleted.loginError'
                  .tr(args: [e.toString()]))),
        );
        Navigator.of(context).pushReplacementNamed(AppRouter.loginRoute);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              const Spacer(),
              Icon(
                widget.icon,
                color: theme.colorScheme.secondary,
                size: 90,
              ),
              const SizedBox(height: 32),
              Text(
                widget.title.tr(),
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                widget.message.tr(),
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontSize: 18,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              if (widget.subtitle != null) ...[
                const SizedBox(height: 12),
                Text(
                  widget.subtitle!.tr(),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _onNextPressed,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'auth.registrationCompleted.goHome'.tr(),
                          style: const TextStyle(fontSize: 20),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
