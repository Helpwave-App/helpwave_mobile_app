import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utils/week_days.dart';
import '../../availability/domain/availability_payload_model.dart';
import '../../availability/data/availability_service.dart';
import '../../../utils/providers.dart';

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

  void addTimeSlot(String day, TimeRange slot) {
    final current = state.valueOrNull;
    if (current == null) return;
    final updated = {...current};
    updated[day] = [...updated[day]!, slot];
    state = AsyncData(updated);
  }

  Future<void> removeTimeSlot(String day, TimeRange slot) async {
    final availability = state.valueOrNull;
    if (availability == null) return;

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
        if (!success) {
          throw Exception('Error al eliminar disponibilidad del servidor');
        }
      } catch (e, st) {
        state = AsyncValue.error(e, st);
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
