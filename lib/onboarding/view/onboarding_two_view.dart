import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/config/theme/custom_theme.dart';

class OnboardingTwoView extends StatelessWidget {
  const OnboardingTwoView({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/images/onboarding-background.png',
            fit: BoxFit.cover,
            width: width,
            height: height,
          ),
          Column(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Image.asset(
                  'assets/images/phone-two.png',
                  height: height * 0.65,
                ),
              ),
              SizedBox(
                height: height * 0.06,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                child: Text(
                  'Select the Music File You Want to Add'.tr(),
                  textAlign: TextAlign.center,
                  style: CustomTheme.textTheme(context).bodyLarge,
                ),
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.only(bottom: height * 0.04),
                child: GestureDetector(
                  onTap: () async {
                    context.go('/onboarding-three');
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
        ],
      ),
    );
  }
}
