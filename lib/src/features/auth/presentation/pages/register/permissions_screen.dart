import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:helpwave_mobile_app/src/routing/app_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../common/animations/animated_route.dart';
import '../../../../../utils/permissions_helper.dart';
import '../../../../notifications/services/device_token_service.dart';

class PermissionsScreen extends StatefulWidget {
  const PermissionsScreen({super.key});

  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen> {
  bool _isRequesting = false;
  late String nextRoute;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    nextRoute = args?['next'] ?? AppRouter.loginRoute;

    _checkPermissionsStatus();
  }

  Future<void> _checkPermissionsStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final permissionsAccepted = prefs.getBool('permissions_accepted') ?? false;

    if (permissionsAccepted) {
      Navigator.of(context).pushReplacement(
        animatedRouteTo(
          context,
          nextRoute,
          curve: Curves.easeInOutBack,
        ),
      );
    }
  }

  Future<void> _requestPermissions() async {
    setState(() => _isRequesting = true);

    final statuses = await [
      Permission.notification,
      Permission.microphone,
      Permission.camera,
    ].request();

    final allGranted = statuses.values.every((status) => status.isGranted);

    if (allGranted) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool('permissions_accepted', true);

      final token =
          await DeviceTokenService.getDeviceToken(requestPermission: true);
      print('🔥 Token del dispositivo: $token');

      Navigator.of(context).pushReplacement(
        animatedRouteTo(
          context,
          nextRoute,
          curve: Curves.easeInOutBack,
        ),
      );
    } else {
      final handledNotification = await checkAndHandlePermanentDenial(
        context: context,
        permission: Permission.notification,
        permissionName: 'notificaciones',
      );

      final handledMicrophone = await checkAndHandlePermanentDenial(
        context: context,
        permission: Permission.microphone,
        permissionName: 'micrófono',
      );

      final handledCamera = await checkAndHandlePermanentDenial(
        context: context,
        permission: Permission.camera,
        permissionName: 'cámara',
      );

      if (!handledNotification && !handledMicrophone && !handledCamera) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Debes aceptar todos los permisos para continuar.'),
          ),
        );
      }

      setState(() => _isRequesting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: theme.secondary,
      body: Column(
        children: [
          const SizedBox(height: 80),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: theme.surface),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(height: 8),
                Text(
                  'Permisos requeridos',
                  style: TextStyle(
                    color: theme.surface,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.surface,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        'Para funcionar correctamente, HelpWave necesita acceso a:\n\n'
                        '- Notificaciones (para avisarte de solicitudes)\n'
                        '- Micrófono y Cámara (para videollamadas)\n',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _isRequesting ? null : _requestPermissions,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isRequesting
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Aceptar y continuar'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
