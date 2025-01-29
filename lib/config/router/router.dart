import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/library/view/library_view.dart';
import 'package:music_app/music_detail/view/music_detail_view.dart';
import 'package:music_app/playlist_add_music/view/playlist_add_music_view.dart';
import 'package:music_app/playlist_detail/view/playlist_detail_view.dart';
import 'package:music_app/playlists/view/playlists_view.dart';
import 'package:music_app/settings/view/settings_view.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/library',
  routes: [
    GoRoute(
      path: '/library',
      name: 'library',
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: LibraryView()),
    ),
    GoRoute(
      path: '/playlists',
      name: 'playlists',
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: PlaylistsView()),
    ),
    GoRoute(
      path: '/playlist-detail/:id',
      name: 'playlist-detail',
      pageBuilder: (context, state) {
        final id = state.pathParameters['id'] as String;
        return NoTransitionPage(
          child: PlaylistDetailView(playlistId: id),
        );
      },
    ),
    GoRoute(
      path: '/settings',
      name: 'settings',
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: SettingsView()),
    ),
    GoRoute(
      path: '/music-detail',
      name: 'music-detail',
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: MusicDetailView()),
    ),
    GoRoute(
      path: '/playlist-add-music',
      pageBuilder: (context, state) {
        final musicId = state.extra as int;
        return NoTransitionPage(child: PlaylistAddMusicView(musicId: musicId));
      },
    ),
  ],
);
