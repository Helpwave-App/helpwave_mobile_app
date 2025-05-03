import 'package:flutter/material.dart';

import '../../domain/profile_model.dart';

class ProfileInfoCard extends StatelessWidget {
  final Profile profile;

  const ProfileInfoCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          _ProfileTile(
              icon: Icons.email, label: 'Correo', value: profile.email),
          _ProfileTile(
              icon: Icons.phone, label: 'Teléfono', value: profile.phone),
          _ProfileTile(
            icon: Icons.cake,
            label: 'Cumpleaños',
            value: profile.birthday != null
                ? _formatDate(profile.birthday!)
                : 'No especificado',
          ),
          _ProfileTile(
              icon: Icons.emoji_events,
              label: 'Nivel',
              value: profile.level.toString()),
          _ProfileTile(
              icon: Icons.star,
              label: 'Puntaje',
              value: profile.scoreProfile.toStringAsFixed(1)),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ProfileTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(icon, color: theme.colorScheme.primary),
      title: Text(label),
      subtitle: Text(value.isNotEmpty ? value : 'No especificado'),
    );
  }
}
