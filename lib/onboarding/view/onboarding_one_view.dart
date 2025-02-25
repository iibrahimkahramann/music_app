import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/config/theme/custom_theme.dart';

class OnboardingOneView extends StatelessWidget {
  const OnboardingOneView({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/images/onboarding-one-background.png',
            fit: BoxFit.cover,
            width: width,
            height: height,
          ),
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
                    'Press the Add Music Button to Add Music',
                    textAlign: TextAlign.center,
                    style: CustomTheme.textTheme(context).bodyLarge,
                  ),
                ),
                Spacer(),
                Padding(
                  padding: EdgeInsets.only(bottom: height * 0.02),
                  child: GestureDetector(
                    onTap: () async {
                      context.go('/onboarding-two');
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
                          'Contiune',
                          style: CustomTheme.textTheme(context)
                              .bodyLarge
                              ?.copyWith(color: Colors.white),
                        ),
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
