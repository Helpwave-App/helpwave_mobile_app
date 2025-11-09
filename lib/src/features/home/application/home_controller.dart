import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../localization/codegen_loader.g.dart';
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
    state = state.copyWith(isLoading: true);

    try {
      final permissions = <Permission, String>{
        Permission.camera:
            LocaleKeys.home_controller_permissions_camera.tr(),
        Permission.microphone:
            LocaleKeys.home_controller_permissions_microphone.tr(),
        Permission.notification:
            LocaleKeys.home_controller_permissions_notification.tr(),
      };

      for (final entry in permissions.entries) {
        final permission = entry.key;
        final name = entry.value;

        final isPermanentlyDenied = await checkAndHandlePermanentDenial(
          context: context,
          permission: permission,
          permissionName: name,
        );

        if (isPermanentlyDenied) {
          return;
        }

        final status = await permission.status;
        if (!status.isGranted) {
          final result = await permission.request();
          if (!result.isGranted) {
            return;
          }
        }
      }

      final service = ref.read(videocallServiceProvider);
      final idSkill = state.selectedSkill?.idSkill ?? 1;
      final idRequest = await service.createHelpRequest(idSkill: idSkill);

      if (!context.mounted) return;

      Navigator.of(context)
          .pushNamed(AppRouter.connectingRoute, arguments: idRequest);
    } on ApiException catch (e) {
      String errorMessage;
      switch (e.statusCode) {
        case 429:
          errorMessage = LocaleKeys.home_controller_errors_rateLimit.tr();
          break;
        case 400:
          errorMessage = LocaleKeys.home_controller_errors_invalidData.tr();
          break;
        case 401:
        case 403:
          errorMessage = LocaleKeys.home_controller_errors_unauthorized.tr();
          break;
        default:
          errorMessage = LocaleKeys.home_controller_errors_unexpected
              .tr(args: [e.statusCode.toString()]);
      }
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(LocaleKeys.home_controller_errors_unknown.tr()),
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