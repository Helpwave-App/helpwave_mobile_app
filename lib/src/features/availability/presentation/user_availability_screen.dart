import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../localization/codegen_loader.g.dart';
import '../../../common/utils/constants/providers.dart';
import '../../../common/utils/constants/week_days.dart';
import '../application/user_availability_controller.dart';
import '../domain/add_time_modal.dart';

class UserAvailabilityScreen extends ConsumerStatefulWidget {
  const UserAvailabilityScreen({super.key});

  @override
  UserAvailabilityScreenState createState() => UserAvailabilityScreenState();
}

class UserAvailabilityScreenState
    extends ConsumerState<UserAvailabilityScreen> {
  bool isEditing = false;

  @override
  Widget build(BuildContext context) {
    final availabilityState = ref.watch(userAvailabilityControllerProvider);
    final controller = ref.read(userAvailabilityControllerProvider.notifier);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.availability_screen_title.tr(),
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        backgroundColor: theme.colorScheme.secondary,
        foregroundColor: theme.colorScheme.onSecondary,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.close : Icons.edit),
            onPressed: () async {
              if (isEditing) {
                await controller.loadAvailability();
              }

              setState(() {
                isEditing = !isEditing;
              });
            },
            tooltip: isEditing
                ? LocaleKeys.availability_screen_tooltip_reload.tr()
                : LocaleKeys.availability_screen_tooltip_edit.tr(),
          ),
        ],
      ),
      body: availabilityState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
            child: Text(LocaleKeys.availability_screen_error
                .tr(args: [e.toString()]))),
        data: (availability) => Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: weekDays.length,
                  itemBuilder: (context, index) {
                    final day = weekDays[index];
                    final slots = availability[day]!;

                    return _buildAvailabilityCard(
                      context,
                      day,
                      slots,
                      isEditing,
                      controller,
                    );
                  },
                ),
              ),
              if (isEditing) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: availability.values.any((s) => s.isNotEmpty)
                        ? () async {
                            final success = await controller.saveAvailability();
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(success
                                    ? LocaleKeys.availability_screen_success_saved
                                        .tr()
                                    : LocaleKeys.availability_screen_error_saving
                                        .tr()),
                              ),
                            );
                            if (success) {
                              setState(() {
                                isEditing = false;
                              });
                            }
                          }
                        : null,
                    child: Text(
                        LocaleKeys.availability_screen_button_save.tr()),
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvailabilityCard(
    BuildContext context,
    String day,
    List<TimeRange> slots,
    bool isEditing,
    UserAvailabilityController controller,
  ) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    day,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (isEditing)
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(24)),
                        ),
                        builder: (_) {
                          return AddTimeModal(
                            day: day,
                            onSave: (start, end, applyToAllDays) {
                              controller.addTimeSlot(
                                  day,
                                  TimeRange(start: start, end: end),
                                  applyToAllDays);
                            },
                            onError: (msg) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(content: Text(msg)));
                            },
                          );
                        },
                      );
                    },
                    tooltip: LocaleKeys.availability_screen_tooltip_add.tr(),
                  ),
              ],
            ),
            if (slots.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  LocaleKeys.availability_screen_noAvailability.tr(),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                  ),
                ),
              )
            else
              ...slots.map(
                (slot) {
                  final slotColor = slot.id == null
                      ? theme.colorScheme.onTertiary.withAlpha(128)
                      : theme.colorScheme.primary;

                  return ListTile(
                    title: Text(
                      '${slot.formatStart(context)} - ${slot.formatEnd(context)}',
                      style: TextStyle(color: slotColor),
                    ),
                    trailing: isEditing
                        ? IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: Text(LocaleKeys
                                      .availability_screen_dialog_confirmDelete_title
                                      .tr()),
                                  content: Text(
                                    LocaleKeys
                                        .availability_screen_dialog_confirmDelete_content
                                        .tr(args: [
                                      '${slot.formatStart(context)} - ${slot.formatEnd(context)}'
                                    ]),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(ctx).pop(false),
                                      child: Text(LocaleKeys
                                          .availability_screen_dialog_confirmDelete_cancel
                                          .tr()),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(ctx).pop(true),
                                      child: Text(LocaleKeys
                                          .availability_screen_dialog_confirmDelete_delete
                                          .tr()),
                                    ),
                                  ],
                                ),
                              );

                              if (confirm == true) {
                                try {
                                  await controller.removeTimeSlot(
                                      context, day, slot);
                                } catch (e) {
                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(LocaleKeys
                                            .availability_screen_error_deleting
                                            .tr(args: [e.toString()]))),
                                  );
                                }
                              }
                            },
                          )
                        : null,
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}