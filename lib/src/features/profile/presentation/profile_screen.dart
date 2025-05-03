import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utils/providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final profileAsyncValue = ref.watch(profileFutureProvider);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text(
          'Mi perfil',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: theme.colorScheme.secondary,
        foregroundColor: theme.colorScheme.onSecondary,
        elevation: 0,
      ),
      body: profileAsyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: ${e.toString()}')),
        data: (profile) {
          if (profile == null) {
            return const Center(child: Text('No se pudo cargar el perfil.'));
          }

          final skillsAsyncValue = ref.watch(skillsFutureProvider);

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: theme.colorScheme.primary,
                  backgroundImage: profile.photoUrl.isNotEmpty
                      ? NetworkImage(profile.photoUrl)
                      : null,
                  child: profile.photoUrl.isEmpty
                      ? Icon(
                          Icons.person,
                          size: 50,
                          color: theme.colorScheme.onPrimary,
                        )
                      : null,
                ),
                const SizedBox(height: 16),
                Text(
                  '${profile.firtsName} ${profile.lastName}',
                  style: theme.textTheme.headlineSmall!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    children: [
                      _ProfileTile(
                          icon: Icons.email,
                          label: 'Correo',
                          value: profile.email),
                      _ProfileTile(
                          icon: Icons.phone,
                          label: 'Teléfono',
                          value: profile.phone),
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
                ),
                const SizedBox(height: 24),
                skillsAsyncValue.when(
                  loading: () => const CircularProgressIndicator(),
                  error: (e, _) => Text('Error al cargar habilidades'),
                  data: (skills) => Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.handyman,
                                  color: theme.colorScheme.primary),
                              const SizedBox(width: 8),
                              Text(
                                'Habilidades',
                                style: theme.textTheme.titleMedium!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: skills
                                .map((s) => Chip(label: Text(s)))
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ref.watch(availabilityFutureProvider).when(
                      loading: () => const CircularProgressIndicator(),
                      error: (e, _) => Text('Error al cargar disponibilidad'),
                      data: (availabilities) => Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.access_time,
                                      color: theme.colorScheme.primary),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Disponibilidad',
                                    style: theme.textTheme.titleMedium!
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              ...availabilities.map((a) => ListTile(
                                    leading: const Icon(Icons.calendar_today),
                                    title: Text(_dayLabel(a.day)),
                                    subtitle:
                                        Text('${a.hourStart} - ${a.hourEnd}'),
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
              ],
            ),
          );
        },
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

String _dayLabel(String day) {
  const days = {
    '1': 'Lunes',
    '2': 'Martes',
    '3': 'Miércoles',
    '4': 'Jueves',
    '5': 'Viernes',
    '6': 'Sábado',
    '7': 'Domingo',
  };
  return days[day] ?? 'Día desconocido';
}
