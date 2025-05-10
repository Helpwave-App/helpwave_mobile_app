import 'package:flutter/material.dart';

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
  _AddTimeModalState createState() => _AddTimeModalState();
}

class _AddTimeModalState extends State<AddTimeModal> {
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  bool applyToAllDays = false;

  void _handleSave() {
    if (startTime == null || endTime == null) return;

    final startMinutes = startTime!.hour * 60 + startTime!.minute;
    final endMinutes = endTime!.hour * 60 + endTime!.minute;

    if (startMinutes >= endMinutes) {
      Navigator.pop(context);
      widget.onError('La hora de fin debe ser posterior a la hora de inicio');
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
          Text('Agregar horario para ${widget.day}',
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
                  child: Text(startTime?.format(context) ?? "Hora de inicio"),
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
                  child: Text(endTime?.format(context) ?? "Hora de fin"),
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
              const Text("Aplicar a todos los días"),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _handleSave,
                  child: const Text('Guardar'),
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
