import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../localization/codegen_loader.g.dart';
import '../../../common/utils/constants/providers.dart';

class UserSkillsScreen extends ConsumerStatefulWidget {
  const UserSkillsScreen({super.key});

  @override
  ConsumerState<UserSkillsScreen> createState() => _UserSkillsScreenState();
}

class _UserSkillsScreenState extends ConsumerState<UserSkillsScreen> {
  bool isEditing = false;

  @override
  Widget build(BuildContext context) {
    final skills = ref.watch(userSkillsControllerProvider);
    final controller = ref.read(userSkillsControllerProvider.notifier);
    final availableSkills = controller.availableSkills;
    final selected = controller.selectedSkill;
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.skills_userSkills_title.tr()),
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.check : Icons.edit),
            onPressed: () {
              setState(() {
                isEditing = !isEditing;
              });
              FocusScope.of(context).unfocus();
            },
          ),
        ],
        backgroundColor: theme.secondary,
        foregroundColor: theme.onSecondary,
        elevation: 0,
      ),
      body: controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...skills.map((skill) {
                    final isGeneralSkill = skill['idSkill'] == 1;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Container(
                          height: 48,
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                            color: Theme.of(context).chipTheme.backgroundColor,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  skill['skillDesc'],
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (isEditing)
                                isGeneralSkill
                                    ? const Icon(Icons.lock, size: 20)
                                    : GestureDetector(
                                        onTap: () async {
                                          if (skills.length > 1) {
                                            final confirm =
                                                await showDialog<bool>(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: Text(LocaleKeys
                                                    .skills_userSkills_dialog_confirmDeletionTitle
                                                    .tr()),
                                                content: Text(LocaleKeys
                                                    .skills_userSkills_dialog_confirmDeletionMessage
                                                    .tr()),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            context, false),
                                                    child: Text(LocaleKeys
                                                        .skills_userSkills_dialog_cancel
                                                        .tr()),
                                                  ),
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            context, true),
                                                    child: Text(LocaleKeys
                                                        .skills_userSkills_dialog_confirm
                                                        .tr()),
                                                  ),
                                                ],
                                              ),
                                            );
                                            if (confirm == true) {
                                              try {
                                                await controller.removeSkill(
                                                    skill['idSkillProfile']);
                                              } catch (e) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                      content:
                                                          Text(e.toString())),
                                                );
                                              }
                                            }
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(LocaleKeys
                                                    .skills_userSkills_snackbar_keepAtLeastOneSkill
                                                    .tr()),
                                              ),
                                            );
                                          }
                                        },
                                        child:
                                            const Icon(Icons.close, size: 20),
                                      ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                  if (isEditing) ...[
                    const SizedBox(height: 16),
                    DropdownButtonFormField<Map<String, dynamic>>(
                      value: selected,
                      items: availableSkills
                          .map(
                            (skill) => DropdownMenuItem<Map<String, dynamic>>(
                              value: skill,
                              child: Text(skill['skillDesc']),
                            ),
                          )
                          .toList(),
                      onChanged: (value) => controller.selectSkill(value),
                      decoration: InputDecoration(
                        labelText:
                            LocaleKeys.skills_userSkills_label_selectSkill.tr(),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          await controller.addSelectedSkill();
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.toString())),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primary,
                      ),
                      child: Text(
                          LocaleKeys.skills_userSkills_button_addSkill.tr()),
                    ),
                  ],
                ],
              ),
            ),
    );
  }
}
