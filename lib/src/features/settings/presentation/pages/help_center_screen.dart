import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../localization/codegen_loader.g.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final faqs = [
      (
        question: LocaleKeys.configurations_settings_help_center_help_faq_n1,
        answer:
            LocaleKeys.configurations_settings_help_center_help_faq_answer_n1
      ),
      (
        question: LocaleKeys.configurations_settings_help_center_help_faq_n2,
        answer:
            LocaleKeys.configurations_settings_help_center_help_faq_answer_n2
      ),
      (
        question: LocaleKeys.configurations_settings_help_center_help_faq_n3,
        answer:
            LocaleKeys.configurations_settings_help_center_help_faq_answer_n3
      ),
      (
        question: LocaleKeys.configurations_settings_help_center_help_faq_n4,
        answer:
            LocaleKeys.configurations_settings_help_center_help_faq_answer_n4
      ),
      (
        question: LocaleKeys.configurations_settings_help_center_help_faq_n5,
        answer:
            LocaleKeys.configurations_settings_help_center_help_faq_answer_n5
      ),
      (
        question: LocaleKeys.configurations_settings_help_center_help_faq_n6,
        answer:
            LocaleKeys.configurations_settings_help_center_help_faq_answer_n6
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.configurations_settings_help_center_title.tr(),
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: colorScheme.secondary,
        foregroundColor: colorScheme.onSecondary,
        elevation: 0,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 36),
        itemCount: faqs.length,
        separatorBuilder: (context, index) => Center(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            width: MediaQuery.of(context).size.width * 0.8,
            height: 1,
            color: Colors.grey.shade300,
          ),
        ),
        itemBuilder: (context, index) {
          final item = faqs[index];

          return Theme(
            data: theme.copyWith(
              dividerColor: Colors.transparent,
            ),
            child: ExpansionTile(
              tilePadding: const EdgeInsets.symmetric(horizontal: 12),
              childrenPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              title: Text(
                item.question.tr(),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              expandedAlignment: Alignment.topLeft,
              maintainState: true,
              children: [
                Text(
                  item.answer.tr(),
                  textAlign: TextAlign.justify,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
