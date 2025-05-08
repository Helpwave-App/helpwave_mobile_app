import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utils/providers.dart';
import '../domain/profile_model.dart';

class UserInfoScreen extends ConsumerStatefulWidget {
  const UserInfoScreen({super.key});

  @override
  ConsumerState<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends ConsumerState<UserInfoScreen> {
  bool isEditing = false;
  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();

  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController birthdayController;

  bool controllersInitialized = false;

  @override
  void dispose() {
    emailController.dispose();
    phoneController.dispose();
    birthdayController.dispose();
    super.dispose();
  }

  void initControllers(Profile profile) {
    emailController = TextEditingController(text: profile.email);
    phoneController = TextEditingController(text: profile.phone);
    birthdayController = TextEditingController(
      text: profile.birthday != null
          ? '${profile.birthday!.day.toString().padLeft(2, '0')}/${profile.birthday!.month.toString().padLeft(2, '0')}/${profile.birthday!.year}'
          : '',
    );
  }

  DateTime? _parseDate(String dateStr) {
    try {
      if (dateStr.isEmpty) return null;
      final parts = dateStr.split('/');
      if (parts.length != 3) return null;
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);
      final date = DateTime(year, month, day);
      if (date.month != month || date.day != day) return null;
      return date;
    } catch (_) {
      return null;
    }
  }

  Future<void> _saveProfileChanges(Profile profile) async {
    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      return;
    }

    setState(() => isLoading = true);

    final parsedBirthday = _parseDate(birthdayController.text);
    if (parsedBirthday == null) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fecha de nacimiento inválida.')),
      );
      return;
    }

    final result = await ref.read(profileServiceProvider).updateProfile(
          email: emailController.text,
          phone: phoneController.text,
          birthday: parsedBirthday,
        );

    if (mounted) {
      setState(() {
        isEditing = false;
        isLoading = false;
      });

      final message = result
          ? 'Perfil actualizado con éxito'
          : 'Hubo un error al actualizar el perfil';

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));

      if (result) {
        ref.invalidate(profileFutureProvider);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final profileAsyncValue = ref.watch(profileFutureProvider);

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
              icon: isLoading
                  ? const CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white)
                  : const Icon(Icons.check),
              onPressed: () {
                final profile = ref.read(profileFutureProvider).maybeWhen(
                      data: (data) => data,
                      orElse: () => null,
                    );
                if (profile != null) {
                  _saveProfileChanges(profile);
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

          if (!controllersInitialized) {
            initControllers(profile);
            controllersInitialized = true;
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
                        controller: emailController,
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
                        controller: phoneController,
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
                        controller: birthdayController,
                        keyboardType: TextInputType.datetime,
                        decoration: const InputDecoration(
                          labelText: 'Fecha de nacimiento (dd/mm/yyyy)',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'La fecha es requerida';
                          }
                          if (_parseDate(value) == null) {
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
