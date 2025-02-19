import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/db/app_database.dart';
import 'package:music_app/library/controller/library_controller.dart';

final musicFilesProvider = FutureProvider<List<MusicFile>>((ref) async {
  final db = AppDatabase();
  return await db.getAllMusicFiles();
});

final filePickerProvider =
    StateNotifierProvider<FilePickerNotifier, bool>((ref) {
  return FilePickerNotifier();
});

final musicFileProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

// Müzik dosyalarını silen bir FutureProvider
final deleteMusicFileProvider =
    FutureProvider.family<void, int>((ref, id) async {
  final db = ref.watch(musicFileProvider);
  await db.deleteMusicFile(id);

  ref.invalidate(musicFilesProvider);
});

final selectedMusicProviderIndex = StateProvider<int>((ref) => 0);

final playlistProvider = Provider<List<MusicFile>>((ref) {
  // Replace with your logic to get the playlist
  final musicFiles = ref.watch(musicFilesProvider).asData?.value ?? [];
  return musicFiles;
});
