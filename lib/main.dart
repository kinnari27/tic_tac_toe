import 'package:flutter/material.dart';
import 'screens/menu_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Neon Tic Tac Toe',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system, // Supports system light/dark mode
      
      // Modern Light Theme
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.cyan,
          brightness: Brightness.light,
          primary: Colors.cyan.shade600,
          secondary: Colors.pink.shade400,
          surface: const Color(0xFFF5F7FA),
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        useMaterial3: true,
        fontFamily: 'Roboto', // Modern standard system sans-serif
      ),
      
      // Modern Premium Dark Theme
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.cyan,
          brightness: Brightness.dark,
          primary: Colors.cyan.shade400,
          secondary: Colors.pink.shade400,
          surface: const Color(0xFF0F0C20),
        ),
        scaffoldBackgroundColor: const Color(0xFF0F0C20),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      
      home: const MenuScreen(),
    );
  }
}
