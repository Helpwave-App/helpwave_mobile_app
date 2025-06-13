import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';

import '../../../common/utils/constants/providers.dart';
import '../domain/language_model.dart';

class UserLanguagesController extends StateNotifier<List<String>> {
  UserLanguagesController(this.ref) : super([]);

  final Ref ref;
  final Map<String, int> _languageNameToProfileId = {};

  Future<void> loadUserLanguages() async {
    final profileService = ref.read(languageProfileServiceProvider);
    final languageService = ref.read(languageServiceProvider);

    final profileLanguages = await profileService.getLanguagesByUserId();
    final allLanguages = await languageService.fetchLanguages();

    final userLanguageNames = <String>[];

    _languageNameToProfileId.clear();

    for (var lp in profileLanguages) {
      final language = allLanguages.firstWhereOrNull(
        (lang) => lang.idLanguage == lp.idLanguage,
      );

      final name = language?.nameLanguage ?? 'Desconocido';
      userLanguageNames.add(name);
      _languageNameToProfileId[name] = lp.idLanguageProfile;
    }

    state = userLanguageNames;
  }

  Future<void> addLanguage(LanguageModel language) async {
    final profileService = ref.read(languageProfileServiceProvider);
    await profileService.addLanguageToProfile(idLanguage: language.idLanguage);

    await loadUserLanguages();
  }

  Future<void> removeLanguage(String nameLanguage) async {
    if (state.length <= 1) {
      throw Exception('Debe conservar al menos un idioma en su perfil.');
    }

    final profileService = ref.read(languageProfileServiceProvider);
    final idLanguageProfile = _languageNameToProfileId[nameLanguage];

    if (idLanguageProfile == null) {
      throw Exception(
          'No se encontró el identificador del idioma para eliminar.');
    }

    await profileService.removeLanguageFromProfile(idLanguageProfile);

    await loadUserLanguages();
  }
}
