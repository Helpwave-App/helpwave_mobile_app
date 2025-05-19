import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../routing/app_router.dart';
import '../../../../utils/constants/providers.dart';
import '../../../profile/domain/skill_model.dart';

class HomeWidget extends ConsumerStatefulWidget {
  final String greeting;
  final String subtitle;
  final String buttonText;
  final bool isRequester;
  final List<Skill>? skills;

  const HomeWidget({
    super.key,
    required this.greeting,
    required this.subtitle,
    required this.buttonText,
    required this.isRequester,
    this.skills,
  });

  @override
  ConsumerState<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends ConsumerState<HomeWidget> {
  Skill? selectedSkill;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 80,
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'HelpWave',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Configuración',
            onPressed: () {
              Navigator.of(context).pushNamed(AppRouter.settingsRoute);
            },
          )
        ],
        elevation: 0,
        backgroundColor: theme.colorScheme.secondary,
        foregroundColor: theme.colorScheme.onSecondary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Align(
            alignment: Alignment.topCenter,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 32),
                Text(
                  widget.greeting,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  widget.subtitle,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                if (widget.isRequester && widget.skills != null) ...[
                  const SizedBox(height: 16),
                  Center(
                    child: SizedBox(
                      width: 180,
                      height: 180,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: EdgeInsets.zero,
                          backgroundColor: theme.colorScheme.tertiary,
                          foregroundColor: theme.colorScheme.onSecondary,
                          elevation: 6,
                        ),
                        onPressed: () async {
                          final service = ref.read(videocallServiceProvider);
                          final idSkill = selectedSkill?.idSkill ?? 1;
                          try {
                            await service.createHelpRequest(idSkill: idSkill);
                            if (!mounted) return;
                            Navigator.of(context)
                                .pushNamed(AppRouter.connectingRoute);
                          } catch (e) {
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: ${e.toString()}')),
                            );
                          }
                        },
                        child: Text(
                          widget.buttonText,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  DropdownButtonFormField<Skill>(
                    value: selectedSkill,
                    isExpanded: true,
                    hint: const Text('Selecciona una habilidad'),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    items: widget.skills!
                        .map((skill) => DropdownMenuItem(
                              value: skill,
                              child: Text(skill.skillDesc),
                            ))
                        .toList(),
                    onChanged: (skill) {
                      setState(() {
                        selectedSkill = skill;
                      });
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
