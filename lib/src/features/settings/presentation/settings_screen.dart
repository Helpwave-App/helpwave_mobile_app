import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../localization/codegen_loader.g.dart';
import '../../../common/utils/constants/providers.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  String _getThemeModeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Claro';
      case ThemeMode.dark:
        return 'Oscuro';
      case ThemeMode.system:
        return 'Predeterminado por el sistema';
    }
  }

  void _showThemeSelectorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Consumer(
          builder: (context, ref, _) {
            final currentTheme = ref.watch(themeModeProvider);
            final theme = Theme.of(context);

            return AlertDialog(
              backgroundColor: theme.colorScheme.surface,
              title: Text(
                'Seleccionar tema',
                style: TextStyle(color: theme.colorScheme.onSurface),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: ThemeMode.values.map((mode) {
                  return RadioListTile<ThemeMode>(
                    title: Text(
                      _getThemeModeLabel(mode),
                      style: TextStyle(color: theme.colorScheme.onSurface),
                    ),
                    value: mode,
                    groupValue: currentTheme,
                    activeColor: theme.colorScheme.primary,
                    onChanged: (value) {
                      if (value != null) {
                        ref
                            .read(themeModeProvider.notifier)
                            .setThemeMode(value);
                        Navigator.of(context).pop();
                      }
                    },
                  );
                }).toList(),
              ),
            );
          },
        );
      },
    );
  }

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
              title:
                  Text(LocaleKeys.settings_settings_screen_select_theme.tr()),
              contentPadding: EdgeInsets.zero,
              onTap: () => _showThemeSelectorDialog(context),
            ),
            const _CenteredDivider(),
            const SizedBox(height: 24),
            _SettingsSectionHeader(
              icon: Icons.info_outline,
              title: LocaleKeys.settings_settings_screen_about.tr(),
              theme: theme,
            ),
            ListTile(
              title: Text(
                  LocaleKeys.settings_settings_screen_about_description.tr()),
              contentPadding: EdgeInsets.zero,
              onTap: () {
                // TODO: Navegar a pantalla "Acerca de HelpWave"
              },
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
