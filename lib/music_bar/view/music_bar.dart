import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/config/providers/music_player_provider.dart';
import 'package:music_app/config/theme/custom_theme.dart';
import 'package:music_app/library/provider/library_provider.dart';

class MusicBar extends ConsumerWidget {
  const MusicBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentMusicFile = ref.watch(selectedMusicFileProvider);

    if (currentMusicFile == null) {
      return SizedBox.shrink();
    }

    final musicFilesAsync = ref.watch(musicFilesProvider);

    return musicFilesAsync.when(
      data: (musicFiles) {
        if (musicFiles.isEmpty) {
          return SizedBox.shrink();
        }

        final currentIndex = musicFiles.indexOf(currentMusicFile);
        print('Current Index: $currentIndex');
        print('Current Music File: ${currentMusicFile.fileName}');

        final player = ref.watch(musicPlayerProvider((
          musicFile: currentMusicFile,
          onPrevious: null,
          onNext: null,
        )));

        final screenWidth = MediaQuery.of(context).size.width;
        final screenHeight = MediaQuery.of(context).size.height;

        return GestureDetector(
          onTap: () {
            context.go('/music-detail', extra: {
              'musicFile': currentMusicFile,
              'musicFiles': musicFiles,
              'currentIndex': currentIndex,
              'onPrevious': currentIndex > 0
                  ? () {
                      final previousIndex = currentIndex - 1;
                      final previousMusic = musicFiles[previousIndex];
                      ref.read(selectedMusicFileProvider.notifier).state =
                          previousMusic;
                    }
                  : null,
              'onNext': currentIndex < musicFiles.length - 1
                  ? () {
                      final nextIndex = currentIndex + 1;
                      final nextMusic = musicFiles[nextIndex];
                      ref.read(selectedMusicFileProvider.notifier).state =
                          nextMusic;
                    }
                  : null,
            });
          },
          child: Container(
            width: screenWidth,
            height: screenHeight * 0.1,
            decoration:
                CustomTheme.customBoxDecoration(color: CustomTheme.accentColor),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(screenWidth * 0.03,
                      screenHeight * 0.013, 0, screenHeight * 0.013),
                  child: Container(
                    width: screenWidth * 0.16,
                    height: screenWidth * 0.16,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(8)),
                    child: Icon(
                      Icons.music_note_rounded,
                      size: screenWidth * 0.08,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      screenWidth * 0.02, 0, screenWidth * 0.02, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentMusicFile.fileName.length > 20
                            ? '${currentMusicFile.fileName.substring(0, 17)}...'
                            : currentMusicFile.fileName,
                        style: CustomTheme.textTheme(context).bodyMedium,
                      ),
                      SizedBox(
                        height: screenHeight * 0.002,
                      ),
                      Text(
                        currentMusicFile.createdAt != null
                            ? '${currentMusicFile.createdAt!.day}/${currentMusicFile.createdAt!.month}/${currentMusicFile.createdAt!.year}'
                            : 'Tarih bilgisi yok',
                        style: CustomTheme.textTheme(context)
                            .bodySmall
                            ?.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                IconButton(
                  icon: Icon(player.isPlaying ? Icons.pause : Icons.play_arrow),
                  onPressed: () {
                    print('Play/Pause button pressed');
                    ref
                        .read(musicPlayerProvider((
                          musicFile: currentMusicFile,
                          onPrevious: null,
                          onNext: null,
                        )).notifier)
                        .togglePlay();
                  },
                ),
                IconButton(
                  icon: Icon(Icons.skip_next),
                  onPressed: currentIndex < musicFiles.length - 1
                      ? () {
                          print('Next button pressed');
                          final nextIndex = currentIndex + 1;
                          final nextMusic = musicFiles[nextIndex];
                          print('Next Music File: ${nextMusic.fileName}');
                          ref.read(selectedMusicFileProvider.notifier).state =
                              nextMusic;
                          ref
                              .read(musicPlayerProvider((
                                musicFile: nextMusic,
                                onPrevious: null,
                                onNext: null,
                              )).notifier)
                              .togglePlay();
                        }
                      : null,
                ),
              ],
            ),
          ),
        );
      },
      loading: () => CircularProgressIndicator(),
      error: (error, stack) {
        print('Error: $error');
        return Text('Error: $error');
      },
    );
  }
}
