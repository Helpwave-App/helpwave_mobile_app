import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utils/constants/providers.dart';
import '../domain/profile_model.dart';

class UserInfoController extends StateNotifier<bool> {
  UserInfoController(this.ref) : super(false);

  final Ref ref;
  bool get isLoading => state;

  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final birthdayController = TextEditingController();

  void initControllers(Profile profile) {
    emailController.text = profile.email;
    phoneController.text = profile.phone;
    birthdayController.text = profile.birthday != null
        ? '${profile.birthday!.day.toString().padLeft(2, '0')}/'
            '${profile.birthday!.month.toString().padLeft(2, '0')}/'
            '${profile.birthday!.year}'
        : '';
  }

  DateTime? parseDate(String dateStr) {
    try {
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

  Future<void> saveProfileChanges(
    BuildContext context,
    GlobalKey<FormState> formKey,
    Profile profile,
    VoidCallback? onSuccess,
  ) async {
    if (!formKey.currentState!.validate()) return;

    final parsedBirthday = parseDate(birthdayController.text);
    if (parsedBirthday == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fecha de nacimiento inválida.')),
      );
      return;
    }

    state = true;

    final result = await ref.read(profileServiceProvider).updateProfile(
          email: emailController.text,
          phone: phoneController.text,
          birthday: parsedBirthday,
        );

    state = false;

    if (result) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil editado exitosamente.')),
      );

      ref.invalidate(profileFutureProvider);
      onSuccess?.call();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al guardar los cambios.')),
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    phoneController.dispose();
    birthdayController.dispose();
    super.dispose();
  }
}
