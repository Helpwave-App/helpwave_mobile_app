import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../utils/providers.dart';

class UserSkillsController extends StateNotifier<List<Map<String, dynamic>>> {
  final Ref ref;
  List<Map<String, dynamic>> _allSkills = [];
  Map<String, dynamic>? selectedSkill;
  bool isLoading = true;

  UserSkillsController(this.ref) : super([]) {
    _loadSkills();
  }

  Future<void> _loadSkills() async {
    try {
      state = [];
      isLoading = true;
      final userSkills =
          await ref.read(skillServiceProvider).getSkillsByProfileId();
      _allSkills = (await ref.read(skillServiceProvider).fetchSkills())
          .map((s) => {
                'idSkill': s.idSkill,
                'skillDesc': s.skillDesc,
              })
          .toList();
      state = userSkills;
    } finally {
      isLoading = false;
      state = [...state];
    }
  }

  List<Map<String, dynamic>> get availableSkills {
    final currentIds = state.map((s) => s['idSkill']).toSet();
    return _allSkills.where((s) => !currentIds.contains(s['idSkill'])).toList();
  }

  void selectSkill(Map<String, dynamic>? skill) {
    selectedSkill = skill;
  }

  Future<void> addSelectedSkill() async {
    if (selectedSkill == null) return;

    final idProfile = await ref.read(profileServiceProvider).getProfileId();
    final success = await ref.read(skillServiceProvider).submitVolunteerSkills(
      idProfile: idProfile,
      skillIds: [selectedSkill!['idSkill']],
    );

    if (success) {
      selectedSkill = null;
      await _loadSkills();
    } else {
      throw Exception('Error al agregar habilidad');
    }
  }

  Future<void> removeSkill(int idSkillProfile) async {
    final success =
        await ref.read(skillServiceProvider).deleteSkillProfile(idSkillProfile);
    if (success) {
      state =
          state.where((s) => s['idSkillProfile'] != idSkillProfile).toList();
    } else {
      throw Exception('Error al eliminar habilidad');
    }
  }
}
