import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import '../../../common/exceptions/api_exception.dart';
import '../../../common/utils/constants/providers.dart';
import '../../../common/utils/permissions_helper.dart';
import '../../../routing/app_router.dart';
import '../../skills/domain/skill_model.dart';

class HomeState {
  final Skill? selectedSkill;
  final bool isLoading;

  HomeState({this.selectedSkill, this.isLoading = false});

  HomeState copyWith({Skill? selectedSkill, bool? isLoading}) {
    return HomeState(
      selectedSkill: selectedSkill ?? this.selectedSkill,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class HomeController extends StateNotifier<HomeState> {
  final Ref ref;
  HomeController(this.ref) : super(HomeState());

  void selectSkill(Skill? skill) {
    state = state.copyWith(selectedSkill: skill);
  }

  Future<void> handleHelpRequest(BuildContext context) async {
    if (state.selectedSkill == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Por favor, selecciona una habilidad antes de continuar.'),
        ),
      );
      return;
    }

    state = state.copyWith(isLoading: true);

    try {
      final hasPermissions = await checkAndRequestEssentialPermissions(context);
      if (!hasPermissions) return;

      final service = ref.read(videocallServiceProvider);
      final idSkill = state.selectedSkill!.idSkill;
      final idRequest = await service.createHelpRequest(idSkill: idSkill);

      if (!context.mounted) return;

      Navigator.of(context)
          .pushNamed(AppRouter.connectingRoute, arguments: idRequest);
    } on ApiException catch (e) {
      String errorMessage;
      switch (e.statusCode) {
        case 429:
          errorMessage =
              'Ya realizaste una solicitud recientemente. Espera un momento antes de volver a intentarlo.';
          break;
        case 400:
          errorMessage =
              'Datos inválidos: verifica tu perfil o habilidad seleccionada.';
          break;
        case 401:
        case 403:
          errorMessage = 'No autorizado. Por favor, inicia sesión nuevamente.';
          break;
        default:
          errorMessage =
              'Error inesperado [${e.statusCode}]. Intenta nuevamente.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
              'Ocurrió un error inesperado. Intenta nuevamente más tarde.'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

final homeControllerProvider = StateNotifierProvider<HomeController, HomeState>(
  (ref) => HomeController(ref),
);
