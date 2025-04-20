import 'package:flutter/material.dart';
import 'src/features/home/presentation/home_screen.dart';

void main() {
  runApp(const HelpWaveApp());
}

class HelpWaveApp extends StatelessWidget {
  const HelpWaveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
