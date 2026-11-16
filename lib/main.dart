import 'package:flutter/material.dart';

import 'splash_screen.dart';

void main() {
  runApp(const CaloPulseApp());
}

class CaloPulseApp extends StatelessWidget {
  const CaloPulseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CaloPulse',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121019),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFAC7BFF),
          brightness: Brightness.dark,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
