import 'package:easy_localization/easy_localization.dart';
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
          Image.asset(
            'assets/images/onboarding-three-background.png',
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
                    'And Enjoy Music without the Internet'.tr(),
                    textAlign: TextAlign.center,
                    style: CustomTheme.textTheme(context).bodyLarge,
                  ),
                ),
                Spacer(),
                Padding(
                  padding: EdgeInsets.only(bottom: height * 0.02),
                  child: GestureDetector(
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
                          'Continue'.tr(),
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
