import 'dart:io';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app/db/app_database.dart';
import 'package:music_app/music_detail/model/music_player_state.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class MusicPlayerNotifier extends StateNotifier<MusicPlayerState> {
  final AudioPlayer _audioPlayer;
  final MusicFile musicFile;

  MusicPlayerNotifier(this.musicFile)
      : _audioPlayer = AudioPlayer(),
        super(MusicPlayerState()) {
    _init();
  }

  Future<void> _init() async {
    try {
      if (Platform.isAndroid) {
        if (!await Permission.audio.request().isGranted) {
          state = state.copyWith(
              errorMessage: 'Permission denied to access audio files');
          return;
        }
      }
      await _initAudioPlayer();
    } catch (e) {
      state = state.copyWith(errorMessage: 'Error initializing player: $e');
    }
  }

  Future<void> _initAudioPlayer() async {
    try {
      String normalizedPath = musicFile.filePath.replaceAll('\\', '/');
      var file = File(normalizedPath);

      print('Dosya bilgileri:');
      print('Original path: ${musicFile.filePath}');
      print('Normalized path: $normalizedPath');
      print('File exists: ${await file.exists()}');

      if (!await file.exists()) {
        // Dosya bulunamadıysa, uygulama dizininde arayalım
        final appDir = await getApplicationDocumentsDirectory();
        final musicDir = Directory('${appDir.path}/music');
        final fileName = path.basename(musicFile.filePath);
        final alternativePath = path.join(musicDir.path, fileName);
        final alternativeFile = File(alternativePath);

        print('Alternatif yol deneniyor:');
        print('Alternative path: $alternativePath');
        print('Alternative file exists: ${await alternativeFile.exists()}');

        if (await alternativeFile.exists()) {
          // Veritabanını güncelle
          await AppDatabase().update(AppDatabase().musicFiles).write(
                MusicFilesCompanion(
                  id: Value(musicFile.id),
                  filePath: Value(alternativePath),
                ),
              );
          normalizedPath = alternativePath;
          file = File(normalizedPath);
          print('Veritabanı güncellendi, yeni yol: $alternativePath');
        } else {
          state = state.copyWith(
            errorMessage:
                'Müzik dosyası bulunamadı.\nOrijinal yol: $normalizedPath\n'
                'Alternatif yol: $alternativePath',
          );
          return;
        }
      }

      // Dosya erişilebilirlik kontrolü
      try {
        final fileSize = await file.length();
        print('File size: $fileSize bytes');
        if (fileSize == 0) {
          state = state.copyWith(errorMessage: 'Dosya boş veya erişilemiyor');
          return;
        }
      } catch (e) {
        print('Dosya erişim hatası: $e');
        state = state.copyWith(errorMessage: 'Dosyaya erişilemiyor: $e');
        return;
      }

      // Müzik oynatıcıyı ayarla
      await _audioPlayer.setFilePath(normalizedPath);
      final duration = await _audioPlayer.duration;
      state = state.copyWith(duration: duration);
      print('Müzik oynatıcı hazır, süre: $duration');

      // Stream'leri dinle
      _audioPlayer.positionStream.listen(
        (position) => state = state.copyWith(position: position),
        onError: (e) => print('Position stream error: $e'),
      );

      _audioPlayer.playerStateStream.listen(
        (playerState) => state = state.copyWith(isPlaying: playerState.playing),
        onError: (e) => print('Player state stream error: $e'),
      );
    } catch (e, stackTrace) {
      print('Hata detayı:');
      print('Error: $e');
      print('Stack trace: $stackTrace');
      state = state.copyWith(
          errorMessage: 'Müzik dosyası yüklenirken hata oluştu: $e');
    }
  }

  Future<bool> _canReadFile(File file) async {
    try {
      final randomAccess = await file.open(mode: FileMode.read);
      await randomAccess.close();
      return true;
    } catch (e) {
      print('File read test failed: $e');
      return false;
    }
  }

  void togglePlay() {
    if (state.isPlaying) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play();
    }
  }

  void seek(Duration position) {
    _audioPlayer.seek(position);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}

final musicPlayerProvider = StateNotifierProvider.family<MusicPlayerNotifier,
    MusicPlayerState, MusicFile>((ref, musicFile) {
  return MusicPlayerNotifier(musicFile);
});
