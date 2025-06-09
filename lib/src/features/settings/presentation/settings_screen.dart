import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../localization/codegen_loader.g.dart';
import '../../../common/utils/constants/providers.dart';
import '../../../routing/app_router.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(
          LocaleKeys.settings_settings_title.tr(),
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: theme.colorScheme.secondary,
        foregroundColor: theme.colorScheme.onSecondary,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title:
                  Text(LocaleKeys.settings_settings_options_viewProfile.tr()),
              onTap: () {
                Navigator.of(context).pushNamed(AppRouter.profileRoute);
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title:
                  Text(LocaleKeys.settings_settings_options_notifications.tr()),
              onTap: () {
                // TODO: Navegar a notificaciones
              },
            ),
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: Text(LocaleKeys.settings_settings_options_helpCenter.tr()),
              onTap: () {
                // TODO: Navegar al centro de ayuda
              },
            ),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: Text(
                LocaleKeys.settings_settings_options_logout.tr(),
                style: const TextStyle(color: Colors.red),
              ),
              onTap: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(
                        LocaleKeys.settings_settings_dialog_logoutTitle.tr()),
                    content: Text(
                        LocaleKeys.settings_settings_dialog_logoutMessage.tr()),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text(
                            LocaleKeys.settings_settings_dialog_cancel.tr()),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Text(
                            LocaleKeys.settings_settings_dialog_confirm.tr()),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => Scaffold(
                      backgroundColor: Colors.transparent,
                      body: Center(
                        child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                  );

                  final authService = ref.read(authServiceProvider);
                  await authService.logout();

                  clearUserSession(ref);

                  if (context.mounted) Navigator.pop(context);

                  if (context.mounted) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRouter.loadingRoute,
                      (route) => false,
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

void clearUserSession(WidgetRef ref) {
  ref.invalidate(profileFutureProvider);
  ref.invalidate(profileProvider);
  ref.invalidate(tempVolunteerProfileProvider);

  ref.invalidate(skillsFutureProvider);
  ref.invalidate(userSkillsProvider);
  ref.invalidate(availabilityFutureProvider);

  ref.invalidate(userRoleProvider);
  ref.invalidate(signUpFormControllerProvider);
  ref.invalidate(userSkillsControllerProvider);
}
