import 'package:flutter/material.dart';

import '../../../../routing/app_router.dart';
import '../../../../common/animations/animated_route.dart';

class RegistrationCompletedWidget extends StatelessWidget {
  final String title;
  final String message;
  final String? subtitle;
  final IconData icon;
  final String userType;

  const RegistrationCompletedWidget({
    super.key,
    required this.title,
    required this.message,
    required this.userType,
    this.subtitle,
    this.icon = Icons.volunteer_activism,
  });

  void _onNextPressed(BuildContext context) {
    final route = userType == "requester"
        ? AppRouter.homeRequesterRoute
        : AppRouter.homeVolunteerRoute;

    Navigator.of(context).push(
      animatedRouteTo(
        context,
        route,
        duration: const Duration(milliseconds: 1000),
        type: RouteTransitionType.pureFade,
        curve: Curves.easeInOutBack,
      ),
    );
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
