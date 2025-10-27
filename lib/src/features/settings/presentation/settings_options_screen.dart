import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../localization/codegen_loader.g.dart';
import '../../../common/utils/constants/providers.dart';
import '../../../routing/app_router.dart';
import '../../requests/application/request_history_controller.dart';

class SettingsOptionsScreen extends ConsumerWidget {
  const SettingsOptionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(
          LocaleKeys.configurations_settings_title.tr(),
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
              title: Text(
                  LocaleKeys.configurations_settings_options_viewProfile.tr()),
              onTap: () {
                Navigator.of(context).pushNamed(AppRouter.profileRoute);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: Text(
                  LocaleKeys.configurations_settings_options_settings.tr()),
              onTap: () {
                Navigator.of(context).pushNamed(AppRouter.settingsRoute);
              },
            ),
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: Text(
                  LocaleKeys.configurations_settings_options_helpCenter.tr()),
              onTap: () {
                Navigator.of(context).pushNamed(AppRouter.helpCenterRoute);
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Historial de solicitudes'),
              onTap: () {
                Navigator.of(context).pushNamed(AppRouter.requestHistoryRoute);
              },
            ),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: Text(
                LocaleKeys.configurations_settings_options_logout.tr(),
                style: const TextStyle(color: Colors.red),
              ),
              onTap: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(LocaleKeys
                        .configurations_settings_dialog_logoutTitle
                        .tr()),
                    content: Text(LocaleKeys
                        .configurations_settings_dialog_logoutMessage
                        .tr()),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text(LocaleKeys
                            .configurations_settings_dialog_cancel
                            .tr()),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Text(LocaleKeys
                            .configurations_settings_dialog_confirm
                            .tr()),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  if (!context.mounted) return;
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
  // Autenticación
  ref.invalidate(signUpFormControllerProvider);
  ref.invalidate(authServiceProvider);

  // Perfil e información
  ref.invalidate(profileFutureProvider);
  ref.invalidate(profileProvider);
  ref.invalidate(tempVolunteerProfileProvider);
  ref.invalidate(userRoleProvider);
  ref.invalidate(userInfoControllerProvider);

  // Idiomas
  ref.invalidate(userLanguagesProvider);
  ref.invalidate(userLanguagesLoaderProvider);

  // Habilidades y disponibilidad
  ref.invalidate(skillsFutureProvider);
  ref.invalidate(userSkillsProvider);
  ref.invalidate(userSkillsControllerProvider);
  ref.invalidate(availabilityFutureProvider);
  ref.invalidate(userAvailabilityControllerProvider);

  // Gamificación
  ref.invalidate(levelProgressControllerProvider);
  ref.invalidate(levelCacheControllerProvider);

  // Solicitudes
  ref.invalidate(requestHistoryControllerProvider);

  // Reportes y feedback
  ref.invalidate(reviewControllerProvider);
  ref.invalidate(typeReportsProvider);
  ref.invalidate(reportSubmissionProvider);
}
