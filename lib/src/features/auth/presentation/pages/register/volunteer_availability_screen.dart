import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../localization/codegen_loader.g.dart';
import '../../../../../common/utils/constants/week_days.dart';
import '../../../../availability/application/user_availability_controller.dart';
import '../../../../availability/data/availability_service.dart';
import '../../../../availability/domain/availability_model.dart';
import '../../../../availability/domain/availability_payload_model.dart';
import '../../../../availability/domain/add_time_modal.dart';
import '../../widgets/day_availability_tile.dart';
import '../../../../../common/animations/animated_route.dart';
import '../../../../../routing/app_router.dart';
import 'package:easy_localization/easy_localization.dart';

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
  bool _isLoading = false;

  final Map<String, List<TimeRange>> _availability = {
    for (final day in weekDays) day: [],
  };

  int _dayNameToNumber(String name) {
    final index = weekDays.indexOf(name);
    if (index == -1) throw ArgumentError('Invalid day name: $name');
    return index + 1;
  }

  String _formatTime24H(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Future<void> _handleNext() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    final List<Availability> availList = [];

    _availability.forEach((dayName, slots) {
      for (final slot in slots) {
        availList.add(
          Availability(
            day: dayName,
            hourStart: _formatTime24H(slot.start),
            hourEnd: _formatTime24H(slot.end),
          ),
        );
      }
    });

    final payload = AvailabilityPayload(
      idProfile: widget.idProfile,
      availabilities: availList,
    );

    final success = await AvailabilityService.saveAvailability(payload);

    if (!mounted) return;

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(LocaleKeys
              .auth_volunteerAvailability_errorSavingAvailability
              .tr()),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      setState(() => _isLoading = false);
      return;
    }

    setState(() => _isLoading = false);

    Navigator.of(context).pushReplacement(
      animatedRouteTo(
        context,
        AppRouter.registrationCompletedVolunteerRoute,
        type: RouteTransitionType.pureFade,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutBack,
        args: {
          'username': widget.username,
          'password': widget.password,
        },
      ),
    );
  }

  bool get _isScheduleComplete =>
      _availability.values.any((slots) => slots.isNotEmpty);

  void _handleDeleteSlot(String day, TimeRange slot) {
    if (_isLoading) return;
    setState(() {
      final slotsCopy = List<TimeRange>.from(_availability[day]!);
      slotsCopy.remove(slot);
      _availability[day] = slotsCopy;
    });
  }

  Future<void> _handleOpenAddTimeDialog(String day) async {
    if (_isLoading) return;
    final rootContext = context;
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
                for (final entry in _availability.entries) {
                  final slotsCopy = List<TimeRange>.from(entry.value);
                  slotsCopy.add(TimeRange(start: start, end: end));
                  _availability[entry.key] = slotsCopy;
                }
              } else {
                final slotsCopy = List<TimeRange>.from(_availability[day]!);
                slotsCopy.add(TimeRange(start: start, end: end));
                _availability[day] = slotsCopy;
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
                LocaleKeys.auth_volunteerAvailability_title.tr(),
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
                      LocaleKeys.auth_volunteerAvailability_subtitle.tr(),
                      style: TextStyle(fontSize: 16, color: theme.onTertiary),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: _availability.keys.map((day) {
                            final slots = _availability[day] ?? [];
                            return DayAvailabilityTile(
                              day: day,
                              slots: slots,
                              onAdd: () => _handleOpenAddTimeDialog(day),
                              onDeleteSlot: (slot) =>
                                  _handleDeleteSlot(day, slot),
                              canEdit: !_isLoading,
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: (_isScheduleComplete && !_isLoading)
                            ? _handleNext
                            : null,
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Text(LocaleKeys
                                .auth_volunteerAvailability_finishRegistration
                                .tr()),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
