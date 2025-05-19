import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../features/auth/data/auth_service.dart';
import '../../features/notifications/services/device_token_service.dart';
import '../../routing/app_router.dart';
import '../../utils/constants/secure_storage.dart';

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
      if (mounted) {
        Navigator.of(context).pushReplacementNamed(AppRouter.welcomeRoute);
      }
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
