import 'package:flutter/material.dart';

import '../../../../../common/animations/animated_route.dart';
import '../../../../../routing/app_router.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      body: Column(
        children: [
          const SizedBox(height: 60),
          Hero(
            tag: 'app-logo',
            child: CircleAvatar(
              radius: 40,
              backgroundColor: Theme.of(context).colorScheme.surface,
              child: Icon(
                Icons.account_balance_wallet,
                color: Theme.of(context).colorScheme.tertiary,
                size: 40,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'HelpWave',
            style: TextStyle(
                color: Theme.of(context).colorScheme.surface,
                fontSize: 24,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Registro",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    const TextField(
                      decoration: InputDecoration(
                          labelText: 'Nombre completo',
                          border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 16),
                    const TextField(
                      decoration: InputDecoration(
                          labelText: 'Número de teléfono',
                          border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 16),
                    const TextField(
                      decoration: InputDecoration(
                          labelText: 'Correo electrónico',
                          border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 16),
                    const TextField(
                      decoration: InputDecoration(
                          labelText: 'Fecha de cumpleaños',
                          border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 16),
                    const TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                          labelText: 'Contraseña',
                          border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(animatedRouteTo(
                            context, AppRouter.termsRoute,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut));
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        backgroundColor: Theme.of(context).colorScheme.tertiary,
                      ),
                      child: const Text("Siguiente"),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("¿Ya tienes una cuenta?",
                              style: TextStyle(color: Colors.grey)),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(animatedRouteTo(
                                  context, AppRouter.loginRoute,
                                  duration: Duration(milliseconds: 200),
                                  curve: Curves.easeInOut));
                            },
                            child: Text("Inicia sesión",
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .tertiary)),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
