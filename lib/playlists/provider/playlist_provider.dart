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

  Future<void> addPlaylistWithImage(
      String playlistName, String? imagePath) async {
    final id = await database.insertPlaylist(
      PlaylistFilesCompanion(
        fileName: Value(playlistName),
        imagePath: Value(imagePath),
        createdAt: Value(DateTime.now()),
      ),
    );
    state = [
      ...state,
      PlaylistFile(
        id: id,
        fileName: playlistName,
        imagePath: imagePath,
        createdAt: DateTime.now(),
      ),
    ];
  }

  Future<void> deletePlaylist(int playlistId) async {
    await database.deletePlaylist(playlistId);
    state = state.where((playlist) => playlist.id != playlistId).toList();
  }
}

final databaseProvider = Provider((ref) => AppDatabase());
final playlistProvider =
    StateNotifierProvider<PlaylistNotifier, List<PlaylistFile>>((ref) {
  final db = ref.read(databaseProvider);
  return PlaylistNotifier(db)..loadPlaylists();
});
