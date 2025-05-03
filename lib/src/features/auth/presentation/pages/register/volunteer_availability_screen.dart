import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../availability/data/availability_service.dart';
import '../../../domain/availability_model.dart';
import '../../widgets/add_time_modal.dart';
import '../../widgets/day_availability_tile.dart';
import '../../../../../common/animations/animated_route.dart';
import '../../../../../routing/app_router.dart';

class VolunteerAvailabilityScreen extends ConsumerStatefulWidget {
  final int idProfile;
  final String username;
  final String password;

  const VolunteerAvailabilityScreen({
    super.key,
    required this.idProfile,
    required this.username,
    required this.password,
  });

  @override
  ConsumerState<VolunteerAvailabilityScreen> createState() =>
      _VolunteerAvailabilityScreenState();
}

class _VolunteerAvailabilityScreenState
    extends ConsumerState<VolunteerAvailabilityScreen> {
  final Map<String, List<TimeRange>> availability = {
    for (final day in weekDays) day: [],
  };

  int _dayNameToNumber(String name) {
    final index = weekDays.indexOf(name);
    if (index == -1) throw ArgumentError('Nombre de día inválido: $name');
    return index + 1;
  }

  String _formatTime24H(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Future<void> _handleNext() async {
    final List<Map<String, String>> availList = [];

    availability.forEach((dayName, slots) {
      final dayIndex = _dayNameToNumber(dayName);
      for (final slot in slots) {
        availList.add({
          'day': '$dayIndex',
          'hourStart': _formatTime24H(slot.start),
          'hourEnd': _formatTime24H(slot.end),
        });
      }
    });

    final payload = {
      'idProfile': widget.idProfile,
      'availabilities': availList,
    };

    final success = await AvailabilityService.saveAvailability(
      AvailabilityPayload.fromMap(payload),
    );

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al guardar disponibilidad')),
      );
      return;
    }

    Navigator.of(context).pushReplacement(animatedRouteTo(
      context,
      AppRouter.registrationCompletedVolunteerRoute,
      type: RouteTransitionType.pureFade,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOutBack,
      args: {
        'username': widget.username,
        'password': widget.password,
      },
    ));
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

    return PopScope(
        canPop: false,
        child: Scaffold(
          backgroundColor: theme.secondary,
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Disponibilidad',
                  style: TextStyle(
                    color: theme.surface,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
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
        ));
  }
}

const List<String> weekDays = [
  'Lunes',
  'Martes',
  'Miércoles',
  'Jueves',
  'Viernes',
  'Sábado',
  'Domingo',
];

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
