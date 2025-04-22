import 'package:flutter/material.dart';

import '../../../routing/app_router.dart';
//import '../../videocall/presentation/videocall_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('HelpWave')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Canal de prueba
            const String channelName = 'testchannel';
            // Token de prueba
            const String token =
                '007eJxTYHhlFtV2ad6zJ4ZR5fqWhQfTI0WqC8tYHjo33C/d/zffRUOBwTzZ3NTMJMU4KdHExMTcIjnJwCTVyDDJ3MTIwCTFINFyChdzRkMgI8OJp0tYGRkgEMTnZihJLS5JzkjMy0vNYWAAACPOIeI=';

            Navigator.of(context).pushNamed(
              AppRouter.videoCallRoute,
              arguments: {
                'token': token,
                'channelName': channelName,
              },
            );
          },
          child: const Text('Iniciar Videollamada'),
        ),
      ),
    );
  }
}
