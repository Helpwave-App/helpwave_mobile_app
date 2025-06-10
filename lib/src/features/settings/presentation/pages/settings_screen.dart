import 'package:app_settings/app_settings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../localization/codegen_loader.g.dart';
import '../dialogs/about_dialog.dart' as custom_about_dialog;
import '../dialogs/theme_selector_dialog.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(
          LocaleKeys.settings_settings_screen_title.tr(),
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: theme.colorScheme.secondary,
        foregroundColor: theme.colorScheme.onSecondary,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SettingsSectionHeader(
              icon: Icons.notifications,
              title: LocaleKeys.settings_settings_screen_notifications.tr(),
              theme: theme,
            ),
            ListTile(
              title: Text(LocaleKeys
                  .settings_settings_screen_open_system_settings
                  .tr()),
              contentPadding: EdgeInsets.zero,
              onTap: () {
                AppSettings.openAppSettings();
              },
            ),
            const _CenteredDivider(),
            const SizedBox(height: 24),
            _SettingsSectionHeader(
              icon: Icons.contrast,
              title: LocaleKeys.settings_settings_screen_app_theme.tr(),
              theme: theme,
            ),
            ListTile(
              title: Text(
                  LocaleKeys.settings_settings_screen_theme_section_title.tr()),
              contentPadding: EdgeInsets.zero,
              onTap: () => showThemeSelectorDialog(context),
            ),
            const _CenteredDivider(),
            const SizedBox(height: 24),
            _SettingsSectionHeader(
              icon: Icons.info_outline,
              title: LocaleKeys.settings_settings_screen_general_section_title
                  .tr(),
              theme: theme,
            ),
            ListTile(
              title: Text(LocaleKeys
                  .settings_settings_screen_general_about_button
                  .tr()),
              contentPadding: EdgeInsets.zero,
              onTap: () => custom_about_dialog.showAboutDialog(context),
            ),
            ListTile(
              title: Text(LocaleKeys.settings_settings_screen_language.tr()),
              contentPadding: EdgeInsets.zero,
              onTap: () {
                // TODO: Navegar a pantalla "Idioma"
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsSectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final ThemeData theme;

  const _SettingsSectionHeader({
    required this.icon,
    required this.title,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.primary),
        ),
      ],
    );
  }
}

class _CenteredDivider extends StatelessWidget {
  const _CenteredDivider();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        child: const Divider(thickness: 1),
      ),
    );
  }
}
