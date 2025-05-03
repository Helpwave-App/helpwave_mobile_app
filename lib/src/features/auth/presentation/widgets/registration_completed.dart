import 'package:flutter/material.dart';

import '../../../../common/pages/loading_screen.dart';
import '../../../../routing/app_router.dart';
import '../../../../utils/secure_storage.dart';
import '../../data/auth_service.dart';
import '../../domain/login_request_model.dart';

class RegistrationCompletedWidget extends StatelessWidget {
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

  void _onNextPressed(BuildContext context) async {
    if (username == null || password == null) return;

    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      final request = LoginRequest(
        username: username!.trim(),
        password: password!.trim(),
      );

      final response = await AuthService().login(request);
      await SecureStorage.saveToken(response.token);
      await SecureStorage.saveIdUser(response.idUser);
      await SecureStorage.saveRole(response.role);

      if (context.mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoadingScreen()),
        );
      }
    } catch (e) {
      if (context.mounted) {
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Error al iniciar sesión: $e')),
        );
        Navigator.of(context).pushReplacementNamed(AppRouter.loginRoute);
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
                icon,
                color: theme.colorScheme.secondary,
                size: 90,
              ),
              const SizedBox(height: 32),
              Text(
                title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                message,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontSize: 18,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 12),
                Text(
                  subtitle!,
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
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  onPressed: () => _onNextPressed(context),
                  child: Text(
                    'Ir al inicio',
                    style: TextStyle(fontSize: 20),
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
