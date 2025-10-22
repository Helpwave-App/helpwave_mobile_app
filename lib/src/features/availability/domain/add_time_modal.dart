import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../localization/codegen_loader.g.dart';

class AddTimeModal extends StatefulWidget {
  final String day;
  final void Function(TimeOfDay start, TimeOfDay end, bool applyAll) onSave;
  final void Function(String message) onError;

  const AddTimeModal({
    super.key,
    required this.day,
    required this.onSave,
    required this.onError,
  });

  @override
  AddTimeModalState createState() => AddTimeModalState();
}

class AddTimeModalState extends State<AddTimeModal> {
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  bool applyToAllDays = false;

  void _handleSave() {
    if (startTime == null || endTime == null) return;

    final startMinutes = startTime!.hour * 60 + startTime!.minute;
    final endMinutes = endTime!.hour * 60 + endTime!.minute;

    if (startMinutes >= endMinutes) {
      Navigator.pop(context);
      widget.onError(
        tr(LocaleKeys.availability_addTimeModal_error_invalidTimeRange),
      );
      return;
    }

    widget.onSave(startTime!, endTime!, applyToAllDays);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 24,
        left: 24,
        right: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${tr(LocaleKeys.availability_addTimeModal_title)} ${widget.day}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (picked != null) setState(() => startTime = picked);
                  },
                  child: Text(
                    startTime?.format(context) ??
                        tr(LocaleKeys.availability_addTimeModal_startTime),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (picked != null) setState(() => endTime = picked);
                  },
                  child: Text(
                    endTime?.format(context) ??
                        tr(LocaleKeys.availability_addTimeModal_endTime),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Checkbox(
                value: applyToAllDays,
                onChanged: (v) => setState(() => applyToAllDays = v ?? false),
              ),
              Text(tr(LocaleKeys.availability_addTimeModal_applyToAll)),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(tr(LocaleKeys.availability_addTimeModal_cancel)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _handleSave,
                  child: Text(tr(LocaleKeys.availability_addTimeModal_save)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
