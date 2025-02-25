import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(
      const Duration(seconds: 2),
      () async {
        final prefs = await SharedPreferences.getInstance();
        final onboardingSeen = prefs.getBool('onboardingSeen') ?? false;
        if (onboardingSeen) {
          context.go('/onboarding-one');
        } else {
          context.go('/onboarding-one');
        }
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
