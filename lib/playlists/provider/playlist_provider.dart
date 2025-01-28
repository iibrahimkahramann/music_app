import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/db/app_database.dart';

class PlaylistNotifier extends StateNotifier<List<PlaylistFile>> {
  final AppDatabase database;

  PlaylistNotifier(this.database) : super([]);

  Future<void> loadPlaylists() async {
    final playlists = await database.getAllPlaylistFiles();
    state = playlists;
  }

  // Yeni bir playlist ekle
  Future<void> addPlaylist(String playlistName) async {
    final id = await database.insertPlaylist(
      PlaylistFilesCompanion(
        fileName: Value(playlistName),
        createdAt: Value(DateTime.now()),
      ),
    );
    state = [
      ...state,
      PlaylistFile(id: id, fileName: playlistName, createdAt: DateTime.now()),
    ];
  }
}

// Provider
final databaseProvider = Provider((ref) => AppDatabase());
final playlistProvider =
    StateNotifierProvider<PlaylistNotifier, List<PlaylistFile>>((ref) {
  final db = ref.read(databaseProvider);
  return PlaylistNotifier(db)..loadPlaylists();
});
