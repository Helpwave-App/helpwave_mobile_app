import 'package:flutter/material.dart';

class ProfileStatCard extends StatelessWidget {
  final IconData? icon;
  final Widget? iconWidget;
  final String value;
  final String label;
  final Color? iconColor;

  const ProfileStatCard({
    super.key,
    this.icon,
    this.iconWidget,
    required this.value,
    required this.label,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          padding: const EdgeInsets.all(8),
          child: iconWidget ??
              Icon(icon, color: iconColor ?? theme.colorScheme.primary),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style:
              theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }
}
