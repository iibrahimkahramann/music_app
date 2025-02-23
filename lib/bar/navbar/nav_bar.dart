import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/config/theme/custom_theme.dart';
import 'package:music_app/music_bar/view/music_bar.dart';

class CustomNavBar extends StatelessWidget {
  const CustomNavBar({
    super.key,
    required this.currentLocation,
  });

  final String currentLocation;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const MusicBar(),
        BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.music_note_rounded,
                size: width * 0.07,
              ),
              label: 'Library'.tr(),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.queue_music_rounded,
                size: width * 0.07,
              ),
              label: 'Playlists'.tr(),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.settings_sharp,
                size: width * 0.07,
              ),
              label: 'Settings'.tr(),
            ),
          ],
          currentIndex: _calculateSelectedIndex(currentLocation),
          selectedItemColor: CustomTheme.accentColor,
          unselectedItemColor: Colors.grey,
          onTap: (index) => _onItemTapped(index, context),
          type: BottomNavigationBarType.fixed,
          backgroundColor:
              CustomTheme.themeData(context).navigationBarTheme.backgroundColor,
        ),
      ],
    );
  }

  int _calculateSelectedIndex(String location) {
    if (location.startsWith('/library')) return 0;
    if (location.startsWith('/playlists')) return 1;
    if (location.startsWith('/settings')) return 2;

    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/library');
        break;

      case 1:
        context.go('/playlists');
        break;
      case 2:
        context.go('/settings');
        break;
    }
  }
}
