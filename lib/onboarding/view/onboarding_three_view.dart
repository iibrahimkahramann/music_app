import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/config/theme/custom_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingThreeView extends StatelessWidget {
  const OnboardingThreeView({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Image.asset('assets/images/onboarding-three-background.png'),
          Padding(
            padding: EdgeInsets.symmetric(vertical: height * 0.02),
            child: Column(
              children: [
                SizedBox(
                  height: height * 0.07,
                ),
                Image.asset(
                  'assets/logos/logo-3x.png',
                  width: width * 0.4,
                ),
                SizedBox(
                  height: height * 0.07,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                  child: Text(
                    'And Enjoy Music without the Internet',
                    textAlign: TextAlign.center,
                    style: CustomTheme.textTheme(context).bodyLarge,
                  ),
                ),
                SizedBox(
                  height: height * 0.62,
                ),
                GestureDetector(
                  onTap: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setBool('onboardingSeen', true);
                    context.go('/library');
                  },
                  child: Container(
                    width: width * 0.93,
                    height: height * 0.07,
                    decoration: BoxDecoration(
                      color: CustomTheme.accentColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        'Let\'s Start',
                        style: CustomTheme.textTheme(context)
                            .bodyLarge
                            ?.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
