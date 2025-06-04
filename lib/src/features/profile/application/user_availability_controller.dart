import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/utils/constants/providers.dart';
import '../../../common/utils/constants/week_days.dart';
import '../data/availability_service.dart';
import '../domain/availability_payload_model.dart';

class UserAvailabilityController
    extends StateNotifier<AsyncValue<Map<String, List<TimeRange>>>> {
  final Ref ref;

  UserAvailabilityController(this.ref) : super(const AsyncLoading()) {
    loadAvailability();
  }

  Future<void> loadAvailability() async {
    try {
      final result =
          await ref.read(availabilityServiceProvider).getAvailabilitiesByUser();

      final map = {for (final day in weekDays) day: <TimeRange>[]};

      for (final item in result) {
        final dayName = weekDays[int.parse(item.day) - 1];
        final start = _parseTime(item.hourStart);
        final end = _parseTime(item.hourEnd);
        map[dayName]?.add(TimeRange(id: '${item.id}', start: start, end: end));
      }

      state = AsyncData(map);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  void addTimeSlot(String day, TimeRange slot, bool applyToAllDays) {
    final current = state.valueOrNull;
    if (current == null) return;

    final updated = {...current};

    if (applyToAllDays) {
      for (var currentDay in weekDays) {
        updated[currentDay] = [...updated[currentDay]!, slot];
      }
    } else {
      updated[day] = [...updated[day]!, slot];
    }

    state = AsyncData(updated);
  }

  Future<void> removeTimeSlot(
      BuildContext context, String day, TimeRange slot) async {
    final availability = state.valueOrNull;
    if (availability == null) return;

    final totalRemainingSlots = availability.values
        .expand((daySlots) => daySlots)
        .where((s) => s.id != null)
        .toList();

    if (totalRemainingSlots.length == 1 &&
        totalRemainingSlots[0].id == slot.id) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Debes tener al menos una disponibilidad')),
      );
      return;
    }

    final updatedSlots = [...availability[day]!];
    updatedSlots.removeWhere(
        (s) => s.start == slot.start && s.end == slot.end && s.id == slot.id);

    final updatedAvailability = {...availability, day: updatedSlots};
    state = AsyncValue.data(updatedAvailability);

    if (slot.id != null) {
      try {
        final success = await ref
            .read(availabilityServiceProvider)
            .deleteAvailability(slot.id!);
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Horario eliminado exitosamente')),
          );
        } else {
          throw Exception('Error al eliminar disponibilidad del servidor');
        }
      } catch (e, st) {
        state = AsyncValue.error(e, st);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar: $e')),
        );
      }
    }
  }

  Future<bool> saveAvailability() async {
    final current = state.valueOrNull;
    if (current == null) return false;

    final idProfile = await ref.read(profileServiceProvider).getProfileId();

    final List<Map<String, dynamic>> newAvailList = [];

    for (final entry in current.entries) {
      final day = entry.key;
      final dayNum = weekDays.indexOf(day) + 1;

      for (final slot in entry.value) {
        if (slot.id == null) {
          newAvailList.add({
            'day': '$dayNum',
            'hourStart': _formatTime24H(slot.start),
            'hourEnd': _formatTime24H(slot.end),
          });
        }
      }
    }

    if (newAvailList.isEmpty) return true;

    final payload = AvailabilityPayload.fromMap({
      'idProfile': idProfile,
      'availabilities': newAvailList,
    });

    final success = await AvailabilityService.saveAvailability(payload);

    if (success) {
      await loadAvailability();
    }

    return success;
  }

  String _formatTime24H(TimeOfDay time) =>
      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

  TimeOfDay _parseTime(String timeStr) {
    final parts = timeStr.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }
}

class TimeRange {
  final String? id;
  final TimeOfDay start;
  final TimeOfDay end;

  TimeRange({this.id, required this.start, required this.end});

  String formatStart(BuildContext context) => start.format(context);
  String formatEnd(BuildContext context) => end.format(context);
}
