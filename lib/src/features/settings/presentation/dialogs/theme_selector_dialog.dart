import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../localization/codegen_loader.g.dart';
import '../../../../common/utils/constants/providers.dart';

String getThemeModeLabel(ThemeMode mode) {
  switch (mode) {
    case ThemeMode.light:
      return LocaleKeys
          .configurations_settings_screen_theme_select_theme_dialog_light
          .tr();
    case ThemeMode.dark:
      return LocaleKeys
          .configurations_settings_screen_theme_select_theme_dialog_dark
          .tr();
    case ThemeMode.system:
      return LocaleKeys
          .configurations_settings_screen_theme_select_theme_dialog_system_default
          .tr();
  }
}

void showThemeSelectorDialog(BuildContext context) {
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
              LocaleKeys
                  .configurations_settings_screen_theme_select_theme_dialog_title
                  .tr(),
              style: TextStyle(color: theme.colorScheme.onSurface),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: ThemeMode.values.map((mode) {
                // ignore: deprecated_member_use
                return RadioListTile<ThemeMode>(
                  title: Text(
                    getThemeModeLabel(mode),
                    style: TextStyle(color: theme.colorScheme.onSurface),
                  ),
                  value: mode,
                  groupValue: currentTheme,
                  activeColor: theme.colorScheme.primary,
                  onChanged: (value) {
                    if (value != null) {
                      ref.read(themeModeProvider.notifier).setThemeMode(value);
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
