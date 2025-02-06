import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(
      const Duration(seconds: 2),
      () async {
        context.go('/onboarding-one');
      },
    );

    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/logos/logo.png',
          width: 150,
          height: 150,
        ),
      ),
    );
  }
}
