import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/config/theme/custom_theme.dart';
import 'package:music_app/library/provider/selected_music_provider.dart';
import 'package:music_app/library/provider/library_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/music_detail/provider/music_player_provider.dart';
import 'package:music_app/services/navigation_service.dart';
import 'package:music_app/db/app_database.dart';

class MusicBar extends ConsumerWidget {
  const MusicBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMusic = ref.watch(selectedMusicProvider);
    final playlist = ref.watch(playlistProvider);

    if (selectedMusic == null) {
      return SizedBox
          .shrink(); // Return an empty widget if no music is selected
    }

    final playerState = ref.watch(musicPlayerProvider(
        (musicFile: selectedMusic, onNext: null, onPrevious: null)));
    final playerNotifier = ref.read(musicPlayerProvider(
        (musicFile: selectedMusic, onNext: null, onPrevious: null)).notifier);

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        // Use NavigationService to navigate to music detail
        NavigationService().setContext(context);
        NavigationService().navigateToMusicDetail(
          selectedMusic,
          playlist,
          ref.read(selectedMusicProviderIndex),
        );
      },
      child: Stack(
        children: [
          Container(
            width: screenWidth,
            height: screenHeight * 0.1,
            decoration: CustomTheme.customBoxDecoration(),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(screenWidth * 0.03,
                screenHeight * 0.013, 0, screenHeight * 0.013),
            child: Container(
              width: screenWidth * 0.16,
              height: screenWidth * 0.16,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
              child: Icon(
                Icons.music_note_rounded,
                size: screenWidth * 0.08,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(screenWidth * 0.22,
                screenHeight * 0.022, 0, screenHeight * 0.022),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      selectedMusic.fileName.length > 23
                          ? '${selectedMusic.fileName.substring(0, 23)}...'
                          : selectedMusic.fileName,
                      style: CustomTheme.textTheme(context).bodyMedium,
                    ),
                    SizedBox(
                      height: screenHeight * 0.002,
                    ),
                    Text(
                      selectedMusic.createdAt != null
                          ? '${selectedMusic.createdAt!.day}/${selectedMusic.createdAt!.month}/${selectedMusic.createdAt!.year}'
                          : 'Tarih bilgisi yok',
                      style: CustomTheme.textTheme(context).bodySmall,
                    ),
                  ],
                ),
                SizedBox(
                  width: screenWidth * 0.1,
                ),
                IconButton(
                  icon: Icon(
                    playerState.isPlaying ? Icons.pause : Icons.play_arrow,
                    size: screenWidth * 0.08,
                  ),
                  onPressed: () {
                    playerNotifier.togglePlay();
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
