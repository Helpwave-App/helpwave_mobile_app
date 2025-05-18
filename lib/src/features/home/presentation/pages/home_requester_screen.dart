import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../utils/constants/providers.dart';
import '../../../profile/data/skill_service.dart';
import '../../../profile/domain/skill_model.dart';
import '../widgets/home_widget.dart';

class HomeRequesterScreen extends ConsumerStatefulWidget {
  const HomeRequesterScreen({super.key});

  @override
  ConsumerState<HomeRequesterScreen> createState() =>
      _HomeRequesterScreenState();
}

class _HomeRequesterScreenState extends ConsumerState<HomeRequesterScreen> {
  late Future<List<Skill>> _skillsFuture;

  @override
  void initState() {
    super.initState();
    _skillsFuture = SkillService().fetchSkills();
  }

  @override
  Widget build(BuildContext context) {
    final authService = ref.read(authServiceProvider);

    return FutureBuilder<bool>(
      future: authService.isTokenValid(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          );
        }

        if (!snapshot.data!) {
          return const Scaffold(
            body: Center(
              child: Text("Sesión expirada. Inicia sesión de nuevo."),
            ),
          );
        }

        final profileAsync = ref.watch(profileFutureProvider);

        return profileAsync.when(
          data: (profile) {
            return FutureBuilder<List<Skill>>(
              future: _skillsFuture,
              builder: (context, skillSnapshot) {
                if (!skillSnapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                return HomeWidget(
                  greeting:
                      '¡Hola, ${profile?.firstName} ${profile?.lastName}!',
                  subtitle: '¿Listo para recibir ayuda hoy?',
                  buttonText: 'Solicitar\nasistencia',
                  isRequester: true,
                  skills: skillSnapshot.data!,
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) =>
              const Center(child: Text('Error cargando perfil')),
        );
      },
    );
  }
}
