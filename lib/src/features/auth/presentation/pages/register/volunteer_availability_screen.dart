import 'package:flutter/material.dart';

import '../../widgets/add_time_modal.dart';
import '../../widgets/day_availability_tile.dart';
import '../../../../../common/animations/animated_route.dart';
import '../../../../../routing/app_router.dart';

class VolunteerAvailabilityScreen extends StatefulWidget {
  const VolunteerAvailabilityScreen({super.key});

  @override
  State<VolunteerAvailabilityScreen> createState() =>
      _VolunteerAvailabilityScreenState();
}

class _VolunteerAvailabilityScreenState
    extends State<VolunteerAvailabilityScreen> {
  final Map<String, List<TimeRange>> availability = {
    'Lunes': [],
    'Martes': [],
    'Miércoles': [],
    'Jueves': [],
    'Viernes': [],
    'Sábado': [],
    'Domingo': [],
  };

  void _handleNext() {
    Navigator.of(context).push(
      animatedRouteTo(
        context,
        AppRouter.registrationCompletedVolunteerRoute,
        duration: const Duration(milliseconds: 1000),
        type: RouteTransitionType.pureFade,
        curve: Curves.easeInOutBack,
      ),
    );
  }

  bool get isScheduleComplete =>
      availability.values.any((times) => times.isNotEmpty);

  void _handleDeleteSlot(String day, TimeRange slot) {
    setState(() {
      availability[day]?.remove(slot);
    });
  }

  void _handleOpenAddTimeDialog(String day) async {
    final rootContext = context; // guardamos el context principal
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return AddTimeModal(
          day: day,
          onSave: (start, end, applyAll) {
            setState(() {
              if (applyAll) {
                for (final entry in availability.entries) {
                  entry.value.add(TimeRange(start: start, end: end));
                }
              } else {
                availability[day]?.add(TimeRange(start: start, end: end));
              }
            });
          },
          onError: (message) {
            ScaffoldMessenger.of(rootContext).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded,
                        color: Colors.white),
                    const SizedBox(width: 8),
                    Expanded(child: Text(message)),
                  ],
                ),
                backgroundColor: Theme.of(rootContext).colorScheme.error,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                duration: const Duration(seconds: 3),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: theme.secondary,
      body: Column(
        children: [
          const SizedBox(height: 80),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: theme.surface),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 8),
                Text(
                  'Disponibilidad',
                  style: TextStyle(
                    color: theme.surface,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.surface,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "¿En qué días y horarios puedes brindar ayuda?",
                    style: TextStyle(fontSize: 16, color: theme.onTertiary),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: availability.keys.map((day) {
                          final slots = availability[day] ?? [];
                          return DayAvailabilityTile(
                            day: day,
                            slots: slots,
                            onAdd: () => _handleOpenAddTimeDialog(day),
                            onDeleteSlot: (slot) =>
                                _handleDeleteSlot(day, slot),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isScheduleComplete ? _handleNext : null,
                      child: const Text('Finalizar registro'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TimeRange {
  final TimeOfDay start;
  final TimeOfDay end;

  TimeRange({required this.start, required this.end});

  String formatStart(BuildContext context) {
    return start.format(context);
  }

  String formatEnd(BuildContext context) {
    return end.format(context);
  }
}
