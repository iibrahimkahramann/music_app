import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/music_player_provider.dart';
import 'package:music_app/config/theme/custom_theme.dart';
import 'package:music_app/library/provider/library_provider.dart';
import 'package:music_app/services/navigation_service.dart';
import 'package:music_app/db/app_database.dart';

class MusicBar extends ConsumerWidget {
  const MusicBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.watch(musicPlayerProvider);
    final currentMusicFile = ref.watch(selectedMusicFileProvider);
    final musicFilesAsync =
        ref.watch(musicFilesProvider); // Müzik dosyaları sağlayıcısı

    return musicFilesAsync.when(
      data: (musicFiles) {
        if (currentMusicFile == null || musicFiles.isEmpty) {
          return SizedBox
              .shrink(); // Eğer seçili müzik veya müzik dosyaları yoksa boş bir widget döndür
        }

        final currentIndex = musicFiles.indexOf(currentMusicFile);

        final screenWidth = MediaQuery.of(context).size.width;
        final screenHeight = MediaQuery.of(context).size.height;

        return GestureDetector(
          onTap: () {
            NavigationService().navigateToMusicDetail(
              currentMusicFile,
              musicFiles,
              currentIndex,
            );
          },
          child: Stack(
            children: [
              Container(
                width: screenWidth,
                height: screenHeight * 0.1,
                decoration: BoxDecoration(color: CustomTheme.accentColor),
              ),
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
                    screenWidth * 0.22,
                    screenHeight * 0.022,
                    screenWidth * 0.05,
                    screenHeight * 0.022),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentMusicFile.fileName.substring(0, 10),
                          style: CustomTheme.textTheme(context).bodyMedium,
                        ),
                        SizedBox(
                          height: screenHeight * 0.002,
                        ),
                        Text(
                          currentMusicFile.createdAt != null
                              ? '${currentMusicFile.createdAt!.day}/${currentMusicFile.createdAt!.month}/${currentMusicFile.createdAt!.year}'
                              : 'Tarih bilgisi yok',
                          style: CustomTheme.textTheme(context).bodySmall,
                        ),
                      ],
                    ),

                    Spacer(), // This will push the IconButton to the right
                    IconButton(
                      icon: Icon(
                        player.playing ? Icons.pause : Icons.play_arrow,
                        size: screenWidth * 0.08,
                      ),
                      onPressed: () {
                        ref
                            .read(musicPlayerProvider.notifier)
                            .togglePlayPause();
                      },
                    ),
                    SizedBox(
                      width: screenWidth * 0.02,
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
      loading: () => CircularProgressIndicator(), // Yükleniyor durumu
      error: (error, stack) => Text('Error: $error'), // Hata durumu
    );
  }
}
