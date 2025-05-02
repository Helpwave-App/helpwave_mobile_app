import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../common/animations/animated_route.dart';
import '../../../../../utils/providers.dart';
import '../../../../../routing/app_router.dart';
import '../../../domain/skill_model.dart';

class VolunteerSkillsScreen extends ConsumerStatefulWidget {
  final int idProfile;
  final String username;
  final String password;

  const VolunteerSkillsScreen({
    super.key,
    required this.idProfile,
    required this.username,
    required this.password,
  });

  @override
  ConsumerState<VolunteerSkillsScreen> createState() =>
      _VolunteerSkillsScreenState();
}

class _VolunteerSkillsScreenState extends ConsumerState<VolunteerSkillsScreen> {
  final Set<int> _selectedSkillIds = {};
  late Future<List<Skill>> _skillsFuture;

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      print('VolunteerSkillsScreen recibió idProfile: ${widget.idProfile}');
    }
    _skillsFuture = ref.read(skillServiceProvider).fetchSkills();
  }

  void _onOptionToggled(int skillId) {
    setState(() {
      if (_selectedSkillIds.contains(skillId)) {
        _selectedSkillIds.remove(skillId);
      } else {
        _selectedSkillIds.add(skillId);
      }
    });
  }

  Future<void> _onFinish() async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    final skillService = ref.read(skillServiceProvider);
    final success = await skillService.submitVolunteerSkills(
      idProfile: widget.idProfile,
      skillIds: _selectedSkillIds.toList(),
    );

    if (kDebugMode) {
      print('idProfile extraído para enviar habilidades: ${widget.idProfile}');
      print('Habilidades seleccionadas: $_selectedSkillIds');
    }

    if (!mounted) return;

    if (!success) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Error al guardar habilidades')),
      );
      return;
    }

    navigator.push(animatedRouteTo(
      context,
      AppRouter.volunteerAvailabilityRoute,
      args: {
        'idProfile': widget.idProfile,
        'username': widget.username,
        'password': widget.password,
      },
      duration: const Duration(milliseconds: 300),
      type: RouteTransitionType.pureFade,
      curve: Curves.easeInOut,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return PopScope(
        canPop: false,
        child: Scaffold(
          backgroundColor: theme.secondary,
          body: Column(
            children: [
              const SizedBox(height: 80),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  '¿En qué áreas puedes brindar ayuda?',
                  style: TextStyle(
                    color: theme.surface,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: theme.surface,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                    ),
                    child: FutureBuilder<List<Skill>>(
                      future: _skillsFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        if (snapshot.hasError) {
                          return Center(
                            child: Text(
                                'Error al cargar habilidades: ${snapshot.error}'),
                          );
                        }

                        final skills = snapshot.data ?? [];

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Puedes marcar más de una opción',
                              style: TextStyle(
                                fontSize: 16,
                                color: theme.onTertiary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Expanded(
                              child: ListView.separated(
                                itemCount: skills.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 8),
                                itemBuilder: (context, index) {
                                  final skill = skills[index];
                                  final isSelected =
                                      _selectedSkillIds.contains(skill.idSkill);

                                  return GestureDetector(
                                    onTap: () =>
                                        _onOptionToggled(skill.idSkill),
                                    child: Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? theme.tertiary.withOpacity(0.2)
                                            : theme.surface.withOpacity(0.1),
                                        border: Border.all(
                                          color: isSelected
                                              ? theme.tertiary
                                              : theme.primary.withOpacity(0.3),
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            isSelected
                                                ? Icons.check_circle
                                                : Icons.circle_outlined,
                                            color: isSelected
                                                ? theme.tertiary
                                                : theme.primary
                                                    .withOpacity(0.6),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              skill.skillDesc,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: theme.onTertiary,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: _selectedSkillIds.isNotEmpty
                                  ? _onFinish
                                  : null,
                              child: const Text('Siguiente'),
                            ),
                          ],
                        );
                      },
                    )),
              ),
            ],
          ),
        ));
  }
}
