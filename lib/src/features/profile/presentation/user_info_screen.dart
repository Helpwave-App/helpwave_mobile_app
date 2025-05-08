import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utils/providers.dart';

class UserInfoScreen extends ConsumerStatefulWidget {
  const UserInfoScreen({super.key});

  @override
  ConsumerState<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends ConsumerState<UserInfoScreen> {
  bool isEditing = false;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final profileAsyncValue = ref.watch(profileFutureProvider);
    final controller = ref.read(userInfoControllerProvider.notifier);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Información de usuario',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        backgroundColor: theme.colorScheme.secondary,
        foregroundColor: theme.colorScheme.onSecondary,
        elevation: 0,
        actions: [
          if (isEditing)
            IconButton(
              icon: controller.isLoading
                  ? const CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white)
                  : const Icon(Icons.check),
              onPressed: () {
                final profile = ref.read(profileFutureProvider).maybeWhen(
                      data: (data) => data,
                      orElse: () => null,
                    );
                if (profile != null) {
                  controller.saveProfileChanges(context, _formKey, profile,
                      () => setState(() => isEditing = false));
                }
              },
            )
          else
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => setState(() => isEditing = true),
            ),
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => setState(() => isEditing = false),
            ),
        ],
      ),
      body: profileAsyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (profile) {
          if (profile == null) {
            return const Center(child: Text('No se pudo cargar el perfil.'));
          }

          if (!controller.controllersInitialized) {
            controller.initControllers(profile);
            controller.controllersInitialized = true;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: theme.colorScheme.primary,
                  backgroundImage: profile.photoUrl.isNotEmpty
                      ? NetworkImage(profile.photoUrl)
                      : null,
                  child: profile.photoUrl.isEmpty
                      ? Icon(Icons.person,
                          size: 50, color: theme.colorScheme.onPrimary)
                      : null,
                ),
                const SizedBox(height: 16),
                Text(
                  '${profile.firstName} ${profile.lastName}',
                  style: theme.textTheme.headlineSmall!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        enabled: isEditing,
                        controller: controller.emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Correo electrónico',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'El correo es requerido';
                          }
                          if (!value.contains('@')) {
                            return 'Correo inválido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        enabled: isEditing,
                        controller: controller.phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: 'Teléfono',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'El teléfono es requerido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        enabled: isEditing,
                        controller: controller.birthdayController,
                        keyboardType: TextInputType.datetime,
                        decoration: const InputDecoration(
                          labelText: 'Fecha de nacimiento (dd/mm/yyyy)',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'La fecha es requerida';
                          }
                          if (controller.parseDate(value) == null) {
                            return 'Formato de fecha inválido';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
