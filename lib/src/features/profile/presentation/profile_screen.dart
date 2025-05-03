import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utils/providers.dart';
import '../../../utils/secure_storage.dart';
import 'widgets/profile_info_card.dart';
import 'widgets/skills_card.dart';
import 'widgets/availability_card.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  String? userRole;

  @override
  void initState() {
    super.initState();
    _loadUserRole();
  }

  Future<void> _loadUserRole() async {
    final role = await SecureStorage.getRole();
    setState(() {
      userRole = role;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final profileAsyncValue = ref.watch(profileFutureProvider);

    if (userRole == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final isVolunteer = userRole == 'volunteer';

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
          final availabilityAsyncValue = ref.watch(availabilityFutureProvider);

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
                ProfileInfoCard(profile: profile),
                if (isVolunteer) ...[
                  const SizedBox(height: 24),
                  skillsAsyncValue.when(
                    loading: () => const CircularProgressIndicator(),
                    error: (e, _) => const Text('Error al cargar habilidades'),
                    data: (skills) => SkillsCard(skills: skills),
                  ),
                  const SizedBox(height: 24),
                  availabilityAsyncValue.when(
                    loading: () => const CircularProgressIndicator(),
                    error: (e, _) =>
                        const Text('Error al cargar disponibilidad'),
                    data: (availabilities) =>
                        AvailabilityCard(availabilities: availabilities),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
