import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../utils/providers.dart';
import '../widgets/home_widget.dart';

class HomeVolunteerScreen extends ConsumerWidget {
  const HomeVolunteerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            body:
                Center(child: Text("Sesión expirada. Inicia sesión de nuevo.")),
          );
        }

        final profileAsync = ref.watch(profileFutureProvider);

        return Scaffold(
          body: profileAsync.when(
            data: (profile) {
              return HomeWidget(
                greeting: '¡Hola, ${profile?.firstName} ${profile?.lastName}!',
                subtitle: '¿Listo para brindar ayuda hoy?',
                buttonText: 'Aceptar\nsolicitud',
              );
            },
            loading: () {
              return Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              );
            },
            error: (err, stack) {
              if (kDebugMode) {
                print('Error al cargar el perfil: $err');
                print('Stack trace: $stack');
              }
              return Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
