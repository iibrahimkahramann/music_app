import 'dart:io';
import 'dart:ui';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app/db/app_database.dart';
import 'package:music_app/music_detail/model/music_player_state.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class MusicPlayerNotifier extends StateNotifier<MusicPlayerState> {
  static AudioPlayer? _currentPlayer;
  final AudioPlayer _audioPlayer;
  final MusicFile musicFile;
  bool _isInitialized = false;

  // Önceki ve sonraki şarkı için callback'ler
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  MusicPlayerNotifier(
    this.musicFile, {
    this.onPrevious,
    this.onNext,
  })  : _audioPlayer = AudioPlayer(),
        super(MusicPlayerState()) {
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    if (_isInitialized) return;

    // Önceki çalan müziği durdur
    if (_currentPlayer != null && _currentPlayer != _audioPlayer) {
      await _currentPlayer?.stop();
      await _currentPlayer?.dispose();
    }
    _currentPlayer = _audioPlayer;

    try {
      if (Platform.isAndroid) {
        if (!await Permission.audio.request().isGranted) {
          state = state.copyWith(
              errorMessage: 'Permission denied to access audio files');
          return;
        }
      }
      await _initAudioPlayer();
      _isInitialized = true;
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
        final appDir = await getApplicationDocumentsDirectory();
        final musicDir = Directory('${appDir.path}/music');
        final fileName = path.basename(musicFile.filePath);
        final alternativePath = path.join(musicDir.path, fileName);
        final alternativeFile = File(alternativePath);

        print('Alternatif yol deneniyor:');
        print('Alternative path: $alternativePath');
        print('Alternative file exists: ${await alternativeFile.exists()}');

        if (await alternativeFile.exists()) {
          // Veritabanını güncelle - sadece file_path'i güncelle
          await (AppDatabase().update(AppDatabase().musicFiles)
                ..where((tbl) => tbl.id.equals(musicFile.id)))
              .write(
            MusicFilesCompanion(
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
      await _audioPlayer.setAudioSource(AudioSource.file(normalizedPath));

      // Stream'leri dinle
      _setupStreams();
    } catch (e, stackTrace) {
      print('Hata detayı:');
      print('Error: $e');
      print('Stack trace: $stackTrace');
      state = state.copyWith(
          errorMessage: 'Müzik dosyası yüklenirken hata oluştu: $e');
    }
  }

  void _setupStreams() {
    _audioPlayer.positionStream.listen(
      (position) => state = state.copyWith(position: position),
      onError: (e) => print('Position stream error: $e'),
    );

    _audioPlayer.playerStateStream.listen(
      (playerState) => state = state.copyWith(isPlaying: playerState.playing),
      onError: (e) => print('Player state stream error: $e'),
    );

    _audioPlayer.durationStream.listen(
      (duration) {
        if (duration != null) {
          state = state.copyWith(duration: duration);
          print('Duration güncellendi: $duration');
        }
      },
      onError: (e) => print('Duration stream error: $e'),
    );
  }

  Future<bool> canReadFile(File file) async {
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

  void toggleLoop() {
    final newLoopMode = state.isLooping ? LoopMode.off : LoopMode.one;
    _audioPlayer.setLoopMode(newLoopMode);
    state = state.copyWith(isLooping: !state.isLooping);
  }

  Future<void> setVolume(double volume) async {
    await _audioPlayer.setVolume(volume);
  }

  // Önceki şarkıya geç
  void previousTrack() {
    onPrevious?.call();
  }

  // Sonraki şarkıya geç
  void nextTrack() {
    onNext?.call();
  }

  @override
  void dispose() {
    try {
      if (_currentPlayer == _audioPlayer) {
        _currentPlayer = null;
      }
      _audioPlayer.stop();
      _audioPlayer.dispose();
      _isInitialized = false;
    } catch (e) {
      print('Dispose error: $e');
    }
    super.dispose();
  }
}

final musicPlayerProvider = StateNotifierProvider.family<
    MusicPlayerNotifier,
    MusicPlayerState,
    ({MusicFile musicFile, VoidCallback? onPrevious, VoidCallback? onNext})>(
  (ref, params) {
    return MusicPlayerNotifier(
      params.musicFile,
      onPrevious: params.onPrevious,
      onNext: params.onNext,
    );
  },
);
