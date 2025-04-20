import 'package:flutter/material.dart';
import '../../videocall/presentation/videocall_screen.dart';

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
            final String channelName = 'testchannel';
            // Token de prueba
            final String token =
                '007eJxTYHhlFtV2ad6zJ4ZR5fqWhQfTI0WqC8tYHjo33C/d/zffRUOBwTzZ3NTMJMU4KdHExMTcIjnJwCTVyDDJ3MTIwCTFINFyChdzRkMgI8OJp0tYGRkgEMTnZihJLS5JzkjMy0vNYWAAACPOIeI=';

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => VideoCallScreen(
                  channelName: channelName,
                  token: token,
                ),
              ),
            );
          },
          child: const Text('Iniciar Videollamada'),
        ),
      ),
    );
  }
}
