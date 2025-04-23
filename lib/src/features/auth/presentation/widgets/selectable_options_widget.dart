import 'package:flutter/material.dart';

class SelectableOptionsWidgetScreen extends StatefulWidget {
  final String title;
  final String subtitle;
  final List<String> options;
  final VoidCallback onFinish;
  final String finishButtonText;

  const SelectableOptionsWidgetScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.options,
    required this.onFinish,
    this.finishButtonText = 'Finalizar',
  });

  @override
  State<SelectableOptionsWidgetScreen> createState() =>
      _SelectableOptionsScreenState();
}

class _SelectableOptionsScreenState
    extends State<SelectableOptionsWidgetScreen> {
  final Set<String> _selectedOptions = {};

  void _onOptionToggled(String option) {
    setState(() {
      if (_selectedOptions.contains(option)) {
        _selectedOptions.remove(option);
      } else {
        _selectedOptions.add(option);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.secondary,
      body: Column(
        children: [
          const SizedBox(height: 80),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: colors.surface),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      color: colors.surface,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
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
                color: colors.surface,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.subtitle,
                    style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onTertiary),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.separated(
                      itemCount: widget.options.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final option = widget.options[index];
                        final isSelected = _selectedOptions.contains(option);

                        return GestureDetector(
                          onTap: () => _onOptionToggled(option),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? colors.tertiary.withOpacity(0.2)
                                  : Theme.of(context)
                                      .colorScheme
                                      .surface
                                      .withOpacity(0.1), //Colors.grey[100]
                              border: Border.all(
                                color: isSelected
                                    ? colors.tertiary
                                    : Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.3), //grey[300]!
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  isSelected
                                      ? Icons.check_circle
                                      : Icons.circle_outlined,
                                  color: isSelected
                                      ? colors.tertiary
                                      : Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(0.6), //grey[600]
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    option,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onTertiary, // grey[800]
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed:
                        _selectedOptions.isNotEmpty ? widget.onFinish : null,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      backgroundColor: colors.tertiary,
                    ),
                    child: Text(widget.finishButtonText),
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
