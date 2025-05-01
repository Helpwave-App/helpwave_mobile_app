import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../../../routing/app_router.dart';
import '../../../../utils/secure_storage.dart';

class StartupScreen extends StatefulWidget {
  const StartupScreen({super.key});

  @override
  State<StartupScreen> createState() => _StartupScreenState();
}

class _StartupScreenState extends State<StartupScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
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
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
