// auth_checker.dart
import 'package:flutter/material.dart';
import 'package:gym_stats/app_scaffold.dart';
import 'package:gym_stats/auth_service.dart';
import 'package:gym_stats/home-page.dart';
import 'package:gym_stats/login_page.dart';

class AuthChecker extends StatelessWidget {
  const AuthChecker({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: AuthService.isLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final isLoggedIn = snapshot.data ?? false;
        return isLoggedIn ? AppScaffold(title: 'Gym Stats', body: const HomePage()) : LoginPage();
      },
    );
  }
}