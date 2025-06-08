import 'package:flutter/material.dart';
import 'start_screen.dart'; // Импорт твоего StartScreen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Система питания',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: const Color(0xFFDFF5E3),
      ),
      home: const StartScreen(),
    );
  }
}
