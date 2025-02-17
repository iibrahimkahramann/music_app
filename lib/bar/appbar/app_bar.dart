import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/config/theme/custom_theme.dart';

class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Column(
        children: [
          SizedBox(
            height: kToolbarHeight,
            child: Padding(
              padding: EdgeInsets.only(right: width * 0.6),
              child: Row(
                children: [
                  Image.asset(
                    'assets/logos/logo.png',
                    height: height * 0.025,
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 1,
            color: CustomTheme.secondaryColor,
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);
}
