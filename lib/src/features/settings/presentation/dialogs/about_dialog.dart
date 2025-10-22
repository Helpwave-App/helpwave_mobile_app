import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../localization/codegen_loader.g.dart';

void showAboutDialog(BuildContext context) {
  final theme = Theme.of(context);
  final Map<String, Map<String, dynamic>> socialMedia = {
    'TikTok': {
      'username': '@helpwave.pe',
      'icon': FontAwesomeIcons.tiktok,
      'url': 'https://www.tiktok.com/@helpwave.pe',
    },
    'Instagram': {
      'username': '@helpwave.pe',
      'icon': FontAwesomeIcons.instagram,
      'url': 'https://www.instagram.com/helpwave.pe',
    },
    'Twitter': {
      'username': '@helpwave_pe',
      'icon': FontAwesomeIcons.twitter,
      'url': 'https://twitter.com/helpwave_pe',
    },
    'Facebook': {
      'username': 'HelpWave Perú',
      'icon': FontAwesomeIcons.facebook,
      'url': 'https://www.facebook.com/helpwave.pe',
    },
  };

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        title: Text(
          LocaleKeys.configurations_settings_screen_general_about_dialog_title
              .tr(),
          style: TextStyle(color: theme.colorScheme.onSurface),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: socialMedia.entries.map((entry) {
            final platform = entry.key;
            final data = entry.value;
            return ListTile(
              leading: Icon(data['icon'], color: theme.colorScheme.primary),
              title: Text(
                platform,
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                data['username'],
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withAlpha(191),
                ),
              ),
              onTap: () async {
                final Uri url = Uri.parse(data['url']);
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.platformDefault);
                }
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            child: Text(
              LocaleKeys
                  .configurations_settings_screen_general_about_dialog_close
                  .tr(),
              style: TextStyle(color: theme.colorScheme.primary),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      );
    },
  );
}
