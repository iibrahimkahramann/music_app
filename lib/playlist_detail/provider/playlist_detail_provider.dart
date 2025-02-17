import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/db/app_database.dart';

final playlistDetailProvider = FutureProvider.autoDispose
    .family<(PlaylistFile, List<MusicFile>), String>((ref, playlistId) async {
  // playlistMusicProvider'ı izle
  ref.watch(playlistMusicProvider(playlistId));

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

// Playlist müzik işlemleri için provider
class PlaylistMusicNotifier extends StateNotifier<List<MusicFile>> {
  final AppDatabase database;
  final int playlistId;

  PlaylistMusicNotifier(this.database, this.playlistId) : super([]) {
    loadPlaylistMusic();
  }

  Future<void> loadPlaylistMusic() async {
    final musicFiles = await database.getMusicInPlaylist(playlistId);
    state = musicFiles;
  }

  Future<void> deleteMusicFromPlaylist(int playlistId, int musicId) async {
    await database.deleteMusicFromPlaylist(playlistId, musicId);
    state = state.where((music) => music.id != musicId).toList();
  }
}

final playlistMusicProvider = StateNotifierProvider.family<
    PlaylistMusicNotifier, List<MusicFile>, String>((ref, playlistId) {
  final db = AppDatabase();
  return PlaylistMusicNotifier(db, int.parse(playlistId));
});
