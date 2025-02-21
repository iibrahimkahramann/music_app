import 'dart:io';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app/db/app_database.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class MusicPlayerNotifier extends StateNotifier<AudioPlayer> {
  MusicPlayerNotifier() : super(AudioPlayer());

  Duration _currentPosition = Duration.zero;
  bool _isPlaying = false;

  Future<void> play(MusicFile musicFile) async {
    try {
      String normalizedPath = musicFile.filePath.replaceAll('\\', '/');
      var file = File(normalizedPath);

      if (!await file.exists()) {
        final appDir = await getApplicationDocumentsDirectory();
        final musicDir = Directory('${appDir.path}/music');
        final fileName = path.basename(musicFile.filePath);
        final alternativePath = path.join(musicDir.path, fileName);
        final alternativeFile = File(alternativePath);

        if (await alternativeFile.exists()) {
          await (AppDatabase().update(AppDatabase().musicFiles)
                ..where((tbl) => tbl.id.equals(musicFile.id)))
              .write(
            MusicFilesCompanion(
              filePath: Value(alternativePath),
            ),
          );

          normalizedPath = alternativePath;
          file = File(normalizedPath);
        } else {
          throw Exception(
              'Müzik dosyası bulunamadı.\nOrijinal yol: $normalizedPath\n'
              'Alternatif yol: $alternativePath');
        }
      }

      final uri = Uri.file(normalizedPath);
      await state.setUrl(uri.toString());
      await state.seek(_currentPosition);
      if (_isPlaying) {
        state.play();
      }
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  void togglePlayPause() {
    if (state.playing) {
      _currentPosition = state.position;
      _isPlaying = false;
      state.pause();
    } else {
      _isPlaying = true;
      state.play();
    }
  }

  void stop() {
    _currentPosition = Duration.zero;
    _isPlaying = false;
    state.stop();
  }

  void disposePlayer() {
    state.dispose();
  }
}

final musicPlayerProvider =
    StateNotifierProvider<MusicPlayerNotifier, AudioPlayer>((ref) {
  return MusicPlayerNotifier();
});
