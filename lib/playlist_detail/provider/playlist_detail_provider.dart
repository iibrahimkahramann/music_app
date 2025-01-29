import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/db/app_database.dart';

final playlistDetailProvider = FutureProvider.autoDispose
    .family<(PlaylistFile, List<MusicFile>), String>((ref, playlistId) async {
  final db = AppDatabase();
  final playlists = await db.getAllPlaylistFiles();
  final playlist =
      playlists.firstWhere((item) => item.id.toString() == playlistId);

  // Get music files in the playlist
  final musicFiles = await db.getMusicInPlaylist(playlist.id);
  final musicCount = musicFiles.length; // Müzik sayısını al

  // Müzik sayısını yazdır
  print('Müzik Sayısı: $musicCount');

  return (playlist, musicFiles);
});

// Provider to trigger refresh
final playlistRefreshProvider = StateProvider<int>((ref) => 0);
