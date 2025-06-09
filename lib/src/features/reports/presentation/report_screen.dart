import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../localization/codegen_loader.g.dart';
import '../../../common/utils/constants/providers.dart';
import '../domain/report_model.dart';
import '../domain/type_report_model.dart';

class ReportScreen extends ConsumerStatefulWidget {
  final int idVideocall;
  const ReportScreen({super.key, required this.idVideocall});

  @override
  ConsumerState<ReportScreen> createState() => _VideocallReportScreenState();
}

class _VideocallReportScreenState extends ConsumerState<ReportScreen> {
  int? _selectedReasonId;
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submitReport() async {
    if (_selectedReasonId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                LocaleKeys.reports_report_screen_snackbar_select_reason.tr())),
      );
      return;
    }

    final profile = ref.read(profileProvider);

    if (profile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(LocaleKeys
                .reports_report_screen_snackbar_profile_not_found
                .tr())),
      );
      return;
    }

    final report = ReportModel(
      idVideocall: widget.idVideocall,
      idProfile: profile.id,
      idTypeReport: _selectedReasonId!,
      descriptionReport: _commentController.text.trim(),
    );

    try {
      await ref.read(reportSubmissionProvider(report).future);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text(LocaleKeys.reports_report_screen_snackbar_success.tr())),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${LocaleKeys.reports_report_screen_snackbar_error.tr()}: ${e.toString()}',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final typesAsync = ref.watch(typeReportsProvider);

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: theme.surface,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            LocaleKeys.reports_report_screen_title.tr(),
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          backgroundColor: theme.secondary,
          foregroundColor: theme.onSecondary,
          elevation: 0,
        ),
        body: typesAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(
            child: Text(
                '${LocaleKeys.reports_report_screen_error_loading.tr()}: $error'),
          ),
          data: (List<TypeReportModel> types) => SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            LocaleKeys.reports_report_screen_description.tr(),
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 24),
                          ...types.map((type) => RadioListTile<int>(
                                value: type.id,
                                groupValue: _selectedReasonId,
                                onChanged: (value) =>
                                    setState(() => _selectedReasonId = value),
                                title: Text(type.description),
                                activeColor: theme.primary,
                              )),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _commentController,
                            maxLines: 4,
                            maxLength: 500,
                            decoration: InputDecoration(
                              hintText: LocaleKeys
                                  .reports_report_screen_comment_hint
                                  .tr(),
                              border: const OutlineInputBorder(),
                              alignLabelWithHint: true,
                            ),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _submitReport,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.tertiary,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                              ),
                              child: Text(LocaleKeys
                                  .reports_report_screen_submit_button
                                  .tr()),
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
