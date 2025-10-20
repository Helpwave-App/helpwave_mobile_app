import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../localization/codegen_loader.g.dart';
import '../../../common/utils/constants/providers.dart';
import 'add_language_dialog.dart';

class UserLanguagesScreen extends ConsumerWidget {
  const UserLanguagesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final userLanguagesAsync = ref.watch(userLanguagesLoaderProvider);
    final userLanguages = ref.watch(userLanguagesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys
              .configurations_settings_screen_general_select_language_button
              .tr(),
        ),
        backgroundColor: theme.colorScheme.secondary,
        foregroundColor: theme.colorScheme.onSecondary,
      ),
      body: userLanguagesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text(
            LocaleKeys
                .configurations_settings_screen_general_select_language_screen_error
                .tr(
              args: [error.toString()],
            ),
          ),
        ),
        data: (_) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Text(
                LocaleKeys
                    .configurations_settings_screen_general_select_language_screen_languages_list
                    .tr(),
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              ...userLanguages.map(
                (languageName) => Card(
                  child: ListTile(
                    title: Text(languageName),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: userLanguages.length > 1
                          ? () async {
                              try {
                                await ref
                                    .read(userLanguagesProvider.notifier)
                                    .removeLanguage(languageName);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      LocaleKeys
                                          .configurations_settings_screen_general_select_language_screen_snackbar_deleted
                                          .tr(),
                                    ),
                                  ),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      LocaleKeys
                                          .configurations_settings_screen_general_select_language_screen_snackbar_error
                                          .tr(args: [e.toString()]),
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          : null,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () async {
                  final result = await showAddLanguageDialog(context, ref);
                  if (result == true) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          LocaleKeys
                              .configurations_settings_screen_general_select_language_screen_snackbar_added
                              .tr(),
                        ),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.add),
                label: Text(LocaleKeys
                    .configurations_settings_screen_general_select_language_screen_add_language
                    .tr()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
