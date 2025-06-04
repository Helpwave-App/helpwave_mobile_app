import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VideocallReportScreen extends ConsumerStatefulWidget {
  const VideocallReportScreen({super.key});

  @override
  ConsumerState<VideocallReportScreen> createState() =>
      _VideocallReportScreenState();
}

class _VideocallReportScreenState extends ConsumerState<VideocallReportScreen> {
  int? _selectedReason;
  final TextEditingController _commentController = TextEditingController();

  final List<String> _reportReasons = [
    'Motivo de reporte 1',
    'Motivo de reporte 2',
    'Motivo de reporte 3',
    'Motivo de reporte 4',
    'Motivo de reporte 5',
    'Motivo de reporte 6',
    'Motivo de reporte 7',
  ];

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submitReport() {
    if (_selectedReason != null) {
      // Aquí deberías llamar a tu controller o Provider para enviar el reporte.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reporte enviado con éxito')),
      );
      Navigator.pop(context); // O redirige a la pantalla deseada
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona un motivo de reporte')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text(
          'Reporte de incidente',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Lamentamos mucho que hayas tenido una mala experiencia. '
              'Por favor, coméntanos lo sucedido para poder brindar una solución.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            ...List.generate(_reportReasons.length, (index) {
              return RadioListTile<int>(
                value: index,
                groupValue: _selectedReason,
                onChanged: (value) => setState(() => _selectedReason = value),
                title: Text(_reportReasons[index]),
                activeColor: colorScheme.primary,
              );
            }),
            const SizedBox(height: 16),
            TextFormField(
              controller: _commentController,
              maxLines: 4,
              maxLength: 500,
              decoration: const InputDecoration(
                hintText: 'Comentario (opcional)',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitReport,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Enviar reporte'),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
