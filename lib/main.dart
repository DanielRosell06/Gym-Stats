import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gym_stats/auth_checker.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';
import 'app_scaffold.dart';
import 'home-page.dart'; // Conteúdo da página inicial

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      title: 'Gym Stats',
      themeMode: themeProvider.themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Color(0xFFFF7F00),
        scaffoldBackgroundColor: Colors.white,
        cardTheme: CardTheme(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        colorScheme: ColorScheme.light(
          primary: Color(0xFFFF7F00),
          secondary: Color(0xFFFFA500),
          tertiary: Color(0xFFFFD700),
          surface: Colors.white,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Color(0xFFFF7F00),
        scaffoldBackgroundColor: Color(0xFF121212),
        cardTheme: CardTheme(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        colorScheme: ColorScheme.dark(
          primary: Color(0xFFFF7F00),
          secondary: Color(0xFFFFA500),
          tertiary: Color(0xFFFFD700),
          surface: Color(0xFF121212),
        ),
      ),
      home: const AuthChecker(),
    );
  }
}
