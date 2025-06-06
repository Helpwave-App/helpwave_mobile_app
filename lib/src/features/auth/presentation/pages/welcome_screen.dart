import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../localization/codegen_loader.g.dart';
import '../../../../common/animations/animated_route.dart';
import '../../../../routing/app_router.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: theme.secondary,
      body: Column(
        children: [
          const SizedBox(height: 100),
          Center(
            child: Column(
              children: [
                Hero(
                  tag: 'app-logo',
                  child: CircleAvatar(
                    radius: 48,
                    backgroundColor: theme.surface,
                    child: Icon(
                      Icons.volunteer_activism,
                      color: theme.tertiary,
                      size: 48,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  LocaleKeys.auth_welcome_title.tr(), // Uso de LocaleKeys
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: theme.surface,
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    LocaleKeys.auth_welcome_subtitle.tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: theme.surface.withOpacity(0.9),
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.surface,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      animatedRouteTo(
                        context,
                        AppRouter.permissionsRoute,
                        args: {'next': AppRouter.loginRoute},
                        curve: Curves.easeInOutBack,
                      ),
                    );
                  },
                  child: Text(LocaleKeys.auth_welcome_signIn.tr()),
                ),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      animatedRouteTo(
                        context,
                        AppRouter.permissionsRoute,
                        args: {'next': AppRouter.userTypeRoute},
                        curve: Curves.easeInOutBack,
                      ),
                    );
                  },
                  child: Text(LocaleKeys.auth_welcome_createAccount.tr()),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
