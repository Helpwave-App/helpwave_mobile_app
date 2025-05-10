import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../utils/providers.dart';
import '../../../auth/data/auth_service.dart';
import '../widgets/home_widget.dart';

class HomeRequesterScreen extends ConsumerWidget {
  const HomeRequesterScreen({super.key});

  Future<bool> _isTokenValid(AuthService authService) {
    return authService.isTokenValid();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService = ref.read(authServiceProvider);

    return FutureBuilder<bool>(
      future: _isTokenValid(authService),
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
                subtitle: '¿Listo para recibir ayuda hoy?',
                buttonText: 'Solicitar\nasistencia',
              );
            },
            loading: () {
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
            error: (err, stack) {
              if (kDebugMode) {
                print('Error al cargar el perfil: $err');
                print('Stack trace: $stack');
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        );
      },
    );
  }
}
