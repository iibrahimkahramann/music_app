import 'dart:io';
import 'dart:ui';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app/db/app_database.dart';
import 'package:music_app/music_detail/model/music_player_state.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class MusicPlayerNotifier extends StateNotifier<MusicPlayerState> {
  static AudioPlayer? _currentPlayer;
  final AudioPlayer _audioPlayer;
  final MusicFile musicFile;
  bool _isInitialized = false;

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

    if (_currentPlayer != null && _currentPlayer != _audioPlayer) {
      await _currentPlayer?.stop();
      await _currentPlayer?.dispose();
    }
    _currentPlayer = _audioPlayer;

    try {
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

      if (!await file.exists()) {
        print('Dosya bulunamadı: $normalizedPath');
        final appDir = await getApplicationDocumentsDirectory();
        final musicDir = Directory('${appDir.path}/music');
        final fileName = path.basename(musicFile.filePath);
        final alternativePath = path.join(musicDir.path, fileName);
        final alternativeFile = File(alternativePath);

        if (await alternativeFile.exists()) {
          print('Alternatif yol bulundu: $alternativePath');
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
          print('Alternatif yol da bulunamadı: $alternativePath');
          state = state.copyWith(
            errorMessage:
                'Müzik dosyası bulunamadı.\nOrijinal yol: $normalizedPath\n'
                'Alternatif yol: $alternativePath',
          );
          return;
        }
      }

      await _audioPlayer.setAudioSource(AudioSource.file(normalizedPath));
      _setupStreams();
    } catch (e) {
      state = state.copyWith(
          errorMessage: 'Müzik dosyası yüklenirken hata oluştu: $e');
    }
  }

  void _setupStreams() {
    _audioPlayer.positionStream.listen(
      (position) => state = state.copyWith(position: position),
    );

    _audioPlayer.playerStateStream.listen(
      (playerState) => state = state.copyWith(isPlaying: playerState.playing),
    );

    _audioPlayer.durationStream.listen(
      (duration) {
        if (duration != null) {
          state = state.copyWith(duration: duration);
        }
      },
    );
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

  void previousTrack() {
    if (onPrevious != null) {
      print('Önceki şarkıya geçiliyor...');
      onPrevious!();
      Future.delayed(Duration(milliseconds: 500), () {
        _audioPlayer.play().then((_) {
          print('Çalma işlemi başlatıldı');
        }).catchError((error) {
          print('Çalma işlemi başlatılamadı: $error');
        });
      });
    } else {
      print('Önceki şarkı callback tanımlı değil');
    }
  }

  void nextTrack() {
    if (onNext != null) {
      print('Sonraki şarkıya geçiliyor...');
      onNext!();
      Future.delayed(Duration(milliseconds: 500), () {
        _audioPlayer.play().then((_) {
          print('Çalma işlemi başlatıldı');
        }).catchError((error) {
          print('Çalma işlemi başlatılamadı: $error');
        });
      });
    } else {
      print('Sonraki şarkı callback tanımlı değil');
    }
  }

  @override
  void dispose() {
    if (_currentPlayer == _audioPlayer) {
      _currentPlayer = null;
    }
    _audioPlayer.stop();
    _audioPlayer.dispose();
    _isInitialized = false;
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
