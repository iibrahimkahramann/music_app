import 'package:flutter/material.dart';
import 'package:music_app/bar/appbar/app_bar.dart';
import 'package:music_app/bar/navbar/nav_bar.dart';
import 'package:music_app/config/theme/custom_theme.dart';

class LibraryView extends StatefulWidget {
  const LibraryView({super.key});

  @override
  State<LibraryView> createState() => _LibraryViewState();
}

class _LibraryViewState extends State<LibraryView> {
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
            children: [
              Row(
                children: [
                  Text(
                    'Library',
                    style: CustomTheme.textTheme(context).bodyLarge,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: width * 0.56),
                    child: Image.asset(
                      'assets/icons/mix.png',
                      height: height * 0.029,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: width * 0.05),
                    child: Image.asset(
                      'assets/icons/list.png',
                      height: height * 0.029,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: height * 0.015,
              ),
              Stack(
                children: [
                  Container(
                    width: width,
                    height: height * 0.1,
                    decoration: CustomTheme.customBoxDecoration(),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        width * 0.03, height * 0.013, 0, height * 0.013),
                    child: Container(
                      width: width * 0.16,
                      height: width * 0.16,
                      decoration: BoxDecoration(
                          color: CustomTheme.accentColor,
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        width * 0.22, height * 0.022, 0, height * 0.022),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Song1',
                              style: CustomTheme.textTheme(context).bodyMedium,
                            ),
                            SizedBox(
                              height: height * 0.002,
                            ),
                            Text('11/12/2003',
                                style:
                                    CustomTheme.textTheme(context).bodySmall),
                          ],
                        ),
                        SizedBox(
                          width: width * 0.5,
                        ),
                        Image.asset(
                          'assets/icons/menu.png',
                          height: height * 0.024,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomNavBar(currentLocation: '/library'),
    );
  }
}
