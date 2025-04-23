import 'package:flutter/material.dart';

import '../../../../common/animations/animated_route.dart';
import '../../../../routing/app_router.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      body: Column(
        children: [
          const SizedBox(height: 80),
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
          const SizedBox(height: 30),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Iniciar Sesión",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  const TextField(
                    decoration: InputDecoration(
                        labelText: 'Email', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 16),
                  const TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                        labelText: 'Contraseña', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: null, // Desactivado inicialmente
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      backgroundColor: Colors.grey[300],
                    ),
                    child: const Text("Iniciar Sesión"),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: TextButton(
                      onPressed: () {},
                      child: Text("¿Olvidaste tu contraseña?",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.tertiary)),
                    ),
                  ),
                  const Spacer(),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("¿Aún no tienes una cuenta?",
                            style: TextStyle(color: Colors.grey)),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(animatedRouteTo(
                                context, AppRouter.registerRoute,
                                duration: Duration(milliseconds: 200),
                                curve: Curves.easeInOut));
                          },
                          child: Text("Regístrate ahora",
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.tertiary)),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
