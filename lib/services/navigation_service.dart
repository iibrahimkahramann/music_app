import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/db/app_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NavigationService {
  static final NavigationService _instance = NavigationService._internal();
  factory NavigationService() => _instance;
  NavigationService._internal();

  late BuildContext _context;
  ProviderContainer? _container;

  void setContext(BuildContext context) {
    _context = context;
  }

  void setContainer(ProviderContainer container) {
    _container = container;
  }

  void navigateToMusicDetail(
    MusicFile musicFile,
    List<MusicFile> playlist,
    int currentIndex,
  ) {
    if (!_context.mounted) return;

    // Önceki müzik çaları dispose et
    _container?.dispose();

    _context.go('/music-detail', extra: {
      'musicFile': musicFile,
      'onPrevious': currentIndex > 0
          ? () => navigateToMusicDetail(
                playlist[currentIndex - 1],
                playlist,
                currentIndex - 1,
              )
          : null,
      'onNext': currentIndex < playlist.length - 1
          ? () => navigateToMusicDetail(
                playlist[currentIndex + 1],
                playlist,
                currentIndex + 1,
              )
          : null,
    });
  }
}
