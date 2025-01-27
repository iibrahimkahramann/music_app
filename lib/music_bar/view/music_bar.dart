import 'package:flutter/material.dart';
import 'package:music_app/config/theme/custom_theme.dart';

class MusicBar extends StatelessWidget {
  const MusicBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        Container(
          width: screenWidth,
          height: screenHeight * 0.1,
          decoration: CustomTheme.customBoxDecoration(),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(screenWidth * 0.03, screenHeight * 0.013,
              0, screenHeight * 0.013),
          child: Container(
            width: screenWidth * 0.16,
            height: screenWidth * 0.16,
            decoration: BoxDecoration(
                color: CustomTheme.accentColor,
                borderRadius: BorderRadius.circular(8)),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(screenWidth * 0.22, screenHeight * 0.022,
              0, screenHeight * 0.022),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'title',
                    style: CustomTheme.textTheme(context).bodyMedium,
                  ),
                  SizedBox(
                    height: screenHeight * 0.002,
                  ),
                  Text(
                    'date',
                    style: CustomTheme.textTheme(context).bodySmall,
                  ),
                ],
              ),
              SizedBox(
                width: screenWidth * 0.5,
              ),
            ],
          ),
        )
      ],
    );
  }
}
