import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/utils/constants/providers.dart';
import '../domain/language_model.dart';

Future<bool?> showAddLanguageDialog(BuildContext context, WidgetRef ref) {
  LanguageModel? selectedLanguage; // Estado persistente

  return showDialog<bool>(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Seleccionar idioma'),
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
                      return const Text(
                        'Ya has agregado todos los idiomas disponibles.',
                        style: TextStyle(fontStyle: FontStyle.italic),
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
                      decoration: const InputDecoration(
                        labelText: 'Idioma',
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
                child: const Text('Cancelar'),
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
                child: const Text('Agregar'),
              ),
            ],
          );
        },
      );
    },
  );
}
