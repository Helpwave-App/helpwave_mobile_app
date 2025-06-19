import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../localization/codegen_loader.g.dart';
import '../../../common/utils/constants/providers.dart';
import '../domain/language_model.dart';

Future<bool?> showAddLanguageDialog(BuildContext context, WidgetRef ref) {
  LanguageModel? selectedLanguage;

  return showDialog<bool>(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(LocaleKeys
                .configurations_settings_screen_general_select_language_screen_dialog_title
                .tr()),
            content: Consumer(
              builder: (context, ref, _) {
                final asyncLanguages = ref.watch(languagesProvider);
                final currentNames = ref.watch(userLanguagesProvider);

                return asyncLanguages.when(
                  data: (languages) {
                    final remaining = languages
                        .where(
                            (lang) => !currentNames.contains(lang.nameLanguage))
                        .toList();

                    if (remaining.isEmpty) {
                      return Text(
                        LocaleKeys
                            .configurations_settings_screen_general_select_language_screen_dialog_no_languages
                            .tr(),
                        style: const TextStyle(fontStyle: FontStyle.italic),
                      );
                    }

                    return DropdownButtonFormField<LanguageModel>(
                      items: remaining.map((lang) {
                        return DropdownMenuItem(
                          value: lang,
                          child: Text(lang.nameLanguage),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedLanguage = value;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: LocaleKeys
                            .configurations_settings_screen_general_select_language_screen_dialog_label
                            .tr(),
                      ),
                      value: selectedLanguage,
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Text('Error: $e'),
                );
              },
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  LocaleKeys
                      .configurations_settings_screen_general_select_language_screen_dialog_cancel
                      .tr(),
                ),
              ),
              ElevatedButton(
                onPressed: selectedLanguage != null
                    ? () async {
                        await ref
                            .read(userLanguagesProvider.notifier)
                            .addLanguage(selectedLanguage!);
                        Navigator.of(context).pop(true);
                      }
                    : null,
                child: Text(
                  LocaleKeys
                      .configurations_settings_screen_general_select_language_screen_dialog_accept
                      .tr(),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}
