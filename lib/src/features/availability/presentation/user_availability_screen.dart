import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/utils/constants/providers.dart';
import '../../../common/utils/constants/week_days.dart';
import '../application/user_availability_controller.dart';
import '../domain/add_time_modal.dart';

class UserAvailabilityScreen extends ConsumerStatefulWidget {
  const UserAvailabilityScreen({super.key});

  @override
  _UserAvailabilityScreenState createState() => _UserAvailabilityScreenState();
}

class _UserAvailabilityScreenState
    extends ConsumerState<UserAvailabilityScreen> {
  bool isEditing = false;

  @override
  Widget build(BuildContext context) {
    final availabilityState = ref.watch(userAvailabilityControllerProvider);
    final controller = ref.read(userAvailabilityControllerProvider.notifier);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Disponibilidad',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
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
            tooltip: isEditing ? 'Recargar Disponibilidad' : 'Editar',
          ),
        ],
      ),
      body: availabilityState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
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
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(success
                                      ? 'Disponibilidad guardada'
                                      : 'Error al guardar disponibilidad'),
                                ),
                              );
                              if (success) isEditing = false;
                            }
                          }
                        : null,
                    child: const Text('Guardar disponibilidad'),
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
                    tooltip: 'Agregar horario',
                  ),
              ],
            ),
            if (slots.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'No se ha registrado disponibilidad',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                  ),
                ),
              )
            else
              ...slots.map(
                (slot) {
                  final slotColor = slot.id == null
                      ? theme.colorScheme.onTertiary.withOpacity(0.5)
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
                                  title: const Text('Confirmar eliminación'),
                                  content: Text(
                                    '¿Deseas eliminar el horario "${slot.formatStart(context)} - ${slot.formatEnd(context)}"?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(ctx).pop(false),
                                      child: const Text('Cancelar'),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(ctx).pop(true),
                                      child: const Text('Eliminar'),
                                    ),
                                  ],
                                ),
                              );

                              if (confirm == true) {
                                try {
                                  await controller.removeTimeSlot(
                                      context, day, slot);
                                } catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text('Error al eliminar: $e')),
                                    );
                                  }
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
