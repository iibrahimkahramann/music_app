import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/db/app_database.dart';
import 'package:music_app/library/view/library_view.dart';
import 'package:music_app/music_detail/view/music_detail_view.dart';
import 'package:music_app/playlist_add_music/view/playlist_add_music_view.dart';
import 'package:music_app/playlist_detail/view/playlist_detail_view.dart';
import 'package:music_app/playlists/view/playlists_view.dart';
import 'package:music_app/settings/view/settings_view.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

Page<dynamic> fadeScalePage(
    {required Widget child, required GoRouterState state}) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: Tween<double>(begin: 1.0, end: 1.0).animate(animation),
          child: child,
        ),
      );
    },
  );
}

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/library',
  routes: [
    GoRoute(
      path: '/library',
      pageBuilder: (context, state) =>
          fadeScalePage(child: const LibraryView(), state: state),
    ),
    GoRoute(
      path: '/playlists',
      pageBuilder: (context, state) =>
          fadeScalePage(child: const PlaylistsView(), state: state),
    ),
    GoRoute(
      path: '/playlist-detail/:id',
      pageBuilder: (context, state) {
        final id = state.pathParameters['id']!;
        return fadeScalePage(
            child: PlaylistDetailView(playlistId: id), state: state);
      },
    ),
    GoRoute(
      path: '/settings',
      pageBuilder: (context, state) =>
          fadeScalePage(child: const SettingsView(), state: state),
    ),
    GoRoute(
      path: '/music-detail',
      pageBuilder: (context, state) {
        final musicFile = state.extra as MusicFile;
        return fadeScalePage(
            child: MusicDetailView(musicFile: musicFile), state: state);
      },
    ),
    GoRoute(
      path: '/playlist-add-music',
      builder: (context, state) {
        final musicId = state.extra as int?;
        final playlistId = state.uri.queryParameters['playlistId'];
        return PlaylistAddMusicView(musicId: musicId, playlistId: playlistId);
      },
    ),
  ],
);
