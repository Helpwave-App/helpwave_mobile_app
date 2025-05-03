import 'package:flutter/material.dart';

import '../../../availability/domain/availability_model.dart';

class AvailabilityCard extends StatelessWidget {
  final List<Availability> availabilities;

  const AvailabilityCard({super.key, required this.availabilities});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.access_time, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Disponibilidad',
                  style: theme.textTheme.titleMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...availabilities.map((a) => ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: Text(_dayLabel(a.day)),
                  subtitle: Text('${a.hourStart} - ${a.hourEnd}'),
                )),
          ],
        ),
      ),
    );
  }

  String _dayLabel(String day) {
    const days = {
      '1': 'Lunes',
      '2': 'Martes',
      '3': 'Miércoles',
      '4': 'Jueves',
      '5': 'Viernes',
      '6': 'Sábado',
      '7': 'Domingo',
    };
    return days[day] ?? 'Día desconocido';
  }
}
