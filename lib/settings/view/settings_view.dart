import 'package:adapty_flutter/adapty_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:lottie/lottie.dart';
import 'package:music_app/bar/appbar/app_bar.dart';
import 'package:music_app/bar/navbar/nav_bar.dart';
import 'package:music_app/config/providers/premium_providers.dart';
import 'package:music_app/config/theme/custom_theme.dart';
import 'package:music_app/firebase/firebase_analytics.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.02, vertical: height * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Settings',
                style: CustomTheme.textTheme(context).bodyLarge,
              ),
              SizedBox(
                height: height * 0.015,
              ),
              GestureDetector(
                onTap: () async {
                  final profile = await Adapty().getProfile();
                  final isPremium =
                      profile.accessLevels['premium']?.isActive ?? false;

                  ref
                      .read(isPremiumProvider.notifier)
                      .updatePremiumStatus(isPremium);

                  if (isPremium) {
                    print("Kullanıcı premium, paywall gösterilmeyecek");
                    return;
                  }

                  final paywall = await Adapty().getPaywall(
                    placementId: 'placement-pro',
                    locale: 'en',
                  );

                  final view = await AdaptyUI().createPaywallView(
                    paywall: paywall,
                  );
                  await view.present();
                  AnalyticsService.analytics
                      .logEvent(name: 'Settings Paywall Giriş');
                },
                child: Stack(children: [
                  Container(
                    width: width * 0.95,
                    height: height * 0.18,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/pro_background.png'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Lottie.asset('assets/json/pro_background.json',
                            width: width * 0.60, height: height * 0.08),
                        Text('Upgrade to Premium',
                            style: CustomTheme.textTheme(context).bodyLarge),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Text('Join us to benefit from privileges',
                            style: CustomTheme.textTheme(context).bodyMedium),
                      ],
                    ),
                  ),
                ]),
              ),
              SizedBox(
                height: height * 0.015,
              ),
              GestureDetector(
                onTap: () async {
                  final url = Uri.parse(
                      'https://sites.google.com/view/music-app-tou/ana-sayfa');
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                child: Container(
                  alignment: Alignment.centerLeft,
                  width: width,
                  height: height * 0.06,
                  decoration: CustomTheme.customBoxDecoration(),
                  child: Row(
                    children: [
                      SizedBox(
                        width: width * 0.05,
                      ),
                      Image.asset('assets/icons/terms.png'),
                      SizedBox(
                        width: width * 0.02,
                      ),
                      Text(
                        'Terms Of Use',
                        style: CustomTheme.textTheme(context).bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.015,
              ),
              GestureDetector(
                onTap: () async {
                  final url = Uri.parse(
                      'https://sites.google.com/view/music-app-pp/ana-sayfa');
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                child: Container(
                  alignment: Alignment.centerLeft,
                  width: width,
                  height: height * 0.06,
                  decoration: CustomTheme.customBoxDecoration(),
                  child: Row(
                    children: [
                      SizedBox(
                        width: width * 0.05,
                      ),
                      Image.asset('assets/icons/privacy.png'),
                      SizedBox(
                        width: width * 0.02,
                      ),
                      Text(
                        'Privacy Policy',
                        style: CustomTheme.textTheme(context).bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.015,
              ),
              GestureDetector(
                onTap: () async {
                  final InAppReview inAppReview = InAppReview.instance;
                  if (await inAppReview.isAvailable()) {
                    await inAppReview.requestReview();
                  } else {
                    print('In-app review is not available');
                  }
                },
                child: Container(
                  alignment: Alignment.centerLeft,
                  width: width,
                  height: height * 0.06,
                  decoration: CustomTheme.customBoxDecoration(),
                  child: Row(
                    children: [
                      SizedBox(
                        width: width * 0.05,
                      ),
                      Image.asset('assets/icons/rateus.png'),
                      SizedBox(
                        width: width * 0.02,
                      ),
                      Text(
                        'Rate Us',
                        style: CustomTheme.textTheme(context).bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomNavBar(currentLocation: '/settings'),
    );
  }
}
