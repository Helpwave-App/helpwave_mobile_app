import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../localization/codegen_loader.g.dart';
import '../../../../routing/app_router.dart';
import '../../../skills/domain/skill_model.dart';
import '../../application/home_controller.dart';

class HomeWidget extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(homeControllerProvider);
    final controller = ref.read(homeControllerProvider.notifier);

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
            tooltip: LocaleKeys.home_widget_settingsTooltip.tr(),
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
                  greeting,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                if (isRequester && skills != null) ...[
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
                        onPressed: state.isLoading
                            ? null
                            : () => controller.handleHelpRequest(context),
                        child: state.isLoading
                            ? const CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                            : Text(
                                buttonText,
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
                    value: state.selectedSkill,
                    isExpanded: true,
                    hint: Text(LocaleKeys.home_widget_selectSkillHint.tr()),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    items: skills!
                        .map((skill) => DropdownMenuItem(
                              value: skill,
                              child: Text(skill.skillDesc),
                            ))
                        .toList(),
                    onChanged: state.isLoading
                        ? null
                        : (skill) => controller.selectSkill(skill),
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
