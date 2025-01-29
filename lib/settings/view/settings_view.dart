import 'package:flutter/material.dart';
import 'package:music_app/bar/appbar/app_bar.dart';
import 'package:music_app/bar/navbar/nav_bar.dart';
import 'package:music_app/config/theme/custom_theme.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
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
              Container(
                alignment: Alignment.center,
                width: width,
                height: height * 0.15,
                decoration: CustomTheme.customBoxDecoration(),
                child: Text(
                  'Premium ol',
                  style: CustomTheme.textTheme(context).bodyLarge,
                ),
              ),
              SizedBox(
                height: height * 0.015,
              ),
              Container(
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
              SizedBox(
                height: height * 0.015,
              ),
              Container(
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
              SizedBox(
                height: height * 0.015,
              ),
              Container(
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
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomNavBar(currentLocation: '/settings'),
    );
  }
}
