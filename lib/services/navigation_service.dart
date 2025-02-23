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
    int currentIndex, {
    VoidCallback? onPrevious,
    VoidCallback? onNext,
  }) {
    if (!_context.mounted) return;

    _context.go('/music-detail', extra: {
      'musicFile': musicFile,
      'musicFiles': musicFiles,
      'currentIndex': currentIndex,
      'onPrevious': onPrevious,
      'onNext': onNext,
    });
  }
}
