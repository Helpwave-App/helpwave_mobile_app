import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../localization/codegen_loader.g.dart';
import '../../../../common/animations/animated_route.dart';
import '../../../../routing/app_router.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  Future<bool> _checkAllPermissions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final permissionsAccepted =
          prefs.getBool('permissions_accepted') ?? false;

      print('🔍 Permissions previously accepted: $permissionsAccepted');

      if (!permissionsAccepted) {
        print('🚫 Permissions not previously accepted');
        return false;
      }

      // SOLO verificar el estado actual SIN usar .isGranted que puede triggerar diálogos
      final notificationStatus = await Permission.notification.status;
      final microphoneStatus = await Permission.microphone.status;
      final cameraStatus = await Permission.camera.status;

      print('📱 Permission statuses:');
      print('  - Notification: $notificationStatus');
      print('  - Microphone: $microphoneStatus');
      print('  - Camera: $cameraStatus');

      // Verificar que todos estén explícitamente granted
      final allGranted = notificationStatus == PermissionStatus.granted &&
          microphoneStatus == PermissionStatus.granted &&
          cameraStatus == PermissionStatus.granted;

      print('✅ All permissions granted: $allGranted');

      // Si los permisos fueron revocados, resetear la preferencia
      if (!allGranted) {
        print('🔄 Resetting permissions_accepted to false');
        await prefs.setBool('permissions_accepted', false);
      }

      return allGranted;
    } catch (e) {
      print('❌ Error checking permissions: $e');
      return false;
    }
  }

  Future<void> _navigateWithPermissionCheck(
      BuildContext context, String nextRoute) async {
    final hasPermissions = await _checkAllPermissions();

    if (hasPermissions) {
      // Si ya tiene todos los permisos, ir directamente a la ruta destino
      Navigator.of(context).push(
        animatedRouteTo(
          context,
          nextRoute,
          curve: Curves.easeInOutBack,
        ),
      );
    } else {
      // Si no tiene permisos, ir a la pantalla de permisos
      Navigator.of(context).push(
        animatedRouteTo(
          context,
          AppRouter.permissionsRoute,
          args: {'next': nextRoute},
          curve: Curves.easeInOutBack,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: theme.secondary,
      body: Column(
        children: [
          const SizedBox(height: 100),
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Hero(
                    tag: 'app-logo',
                    child: Image.asset(
                      'lib/src/assets/images/logo-white.png',
                      width: 180,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    LocaleKeys.auth_welcome_title.tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: theme.surface,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      LocaleKeys.auth_welcome_subtitle.tr(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: theme.surface.withOpacity(0.9),
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.surface,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: () => _navigateWithPermissionCheck(
                    context,
                    AppRouter.loginRoute,
                  ),
                  child: Text(LocaleKeys.auth_welcome_signIn.tr()),
                ),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () => _navigateWithPermissionCheck(
                    context,
                    AppRouter.userTypeRoute,
                  ),
                  child: Text(LocaleKeys.auth_welcome_createAccount.tr()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
