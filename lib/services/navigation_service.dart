import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/db/app_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NavigationService {
  static final NavigationService _instance = NavigationService._internal();
  factory NavigationService() => _instance;
  NavigationService._internal();

  late BuildContext _context;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  void setContext(BuildContext context) {
    _context = context;
  }

  void setContainer(ProviderContainer container) {}

  void navigateToMusicDetail(
    MusicFile musicFile,
    List<MusicFile> musicFiles,
    int currentIndex,
  ) {
    if (!_context.mounted) return;

    _context.go('/music-detail', extra: {
      'musicFile': musicFile,
      'onPrevious': currentIndex > 0
          ? () => navigateToMusicDetail(
                musicFiles[currentIndex - 1],
                musicFiles,
                currentIndex - 1,
              )
          : null,
      'onNext': currentIndex < musicFiles.length - 1
          ? () => navigateToMusicDetail(
                musicFiles[currentIndex + 1],
                musicFiles,
                currentIndex + 1,
              )
          : null,
    });
  }

  Future<dynamic> navigateTo(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!
        .pushNamed(routeName, arguments: arguments);
  }

  void goBack() {
    return navigatorKey.currentState!.pop();
  }
}
