import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../features/notifications/services/device_token_service.dart';
import '../../routing/app_router.dart';
import '../utils/constants/secure_storage.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    await Future.delayed(const Duration(seconds: 2));

    final token = await SecureStorage.getToken();

    if (token != null && !JwtDecoder.isExpired(token)) {
      print('🔑 Token JWT válido encontrado, actualizando FCM token...');

      await _updateFCMToken();

      final decodedToken = JwtDecoder.decode(token);
      final role = decodedToken['role'];

      if (mounted) {
        if (role == 'requester') {
          Navigator.of(context)
              .pushReplacementNamed(AppRouter.homeRequesterRoute);
        } else if (role == 'volunteer') {
          Navigator.of(context)
              .pushReplacementNamed(AppRouter.homeVolunteerRoute);
        } else {
          Navigator.of(context).pushReplacementNamed(AppRouter.loginRoute);
        }
      }
    } else {
      print('❌ Token JWT no válido o expirado');
      if (mounted) {
        Navigator.of(context).pushReplacementNamed(AppRouter.welcomeRoute);
      }
    }
  }

  Future<void> _updateFCMToken() async {
    try {
      print('🔄 Iniciando actualización de token FCM...');

      final deviceTokenService = DeviceTokenService();
      final currentToken = await DeviceTokenService.getDeviceToken();

      if (currentToken == null) {
        print('❌ No se pudo obtener el token FCM actual');
        return;
      }

      print('📱 Registrando/actualizando token FCM: $currentToken');

      await deviceTokenService.registerDeviceToken(
        newToken: currentToken,
      );

      print('✅ Token FCM procesado exitosamente');
    } catch (e) {
      print('❌ Error actualizando token FCM: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
  }
}
