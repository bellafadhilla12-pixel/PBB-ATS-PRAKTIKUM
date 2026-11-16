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
      debugShowCheckedModeBanner: false,
      title: 'CaloPulse',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121019),
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
