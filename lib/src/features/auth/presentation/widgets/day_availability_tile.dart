import 'package:flutter/material.dart';

import '../../../availability/application/user_availability_controller.dart';

class DayAvailabilityTile extends StatelessWidget {
  final String day;
  final List<TimeRange> slots;
  final VoidCallback onAdd;
  final Function(TimeRange) onDeleteSlot;
  final bool canEdit;

  const DayAvailabilityTile({
    super.key,
    required this.day,
    required this.slots,
    required this.onAdd,
    required this.onDeleteSlot,
    this.canEdit = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              day,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (canEdit)
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: onAdd,
              ),
          ],
        ),
        ...slots.map((slot) => ListTile(
              title: Text(
                  '${slot.formatStart(context)} - ${slot.formatEnd(context)}'),
              trailing: canEdit
                  ? IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => onDeleteSlot(slot),
                    )
                  : null,
            )),
        const Divider(),
      ],
    );
  }
}
