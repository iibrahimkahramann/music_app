import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/config/theme/custom_theme.dart';
import 'package:music_app/db/app_database.dart';
import 'package:music_app/music_detail/provider/music_player_provider.dart';

class MusicDetailView extends ConsumerWidget {
  final MusicFile musicFile;

  const MusicDetailView({
    super.key,
    required this.musicFile,
  });

  String _formatDuration(Duration? duration) {
    if (duration == null) return '--:--';
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '$twoDigitMinutes:$twoDigitSeconds';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerState = ref.watch(musicPlayerProvider(musicFile));
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    if (playerState.errorMessage != null) {
      return Center(
        child: Text(
          playerState.errorMessage!,
          style: CustomTheme.textTheme(context)
              .bodyMedium
              ?.copyWith(color: Colors.red),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomTheme.backgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            context.go('/library');
          },
        ),
        title: Padding(
          padding: EdgeInsets.only(left: width * 0.19),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Music Detail',
                style: CustomTheme.textTheme(context)
                    .bodyMedium
                    ?.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.02, vertical: height * 0.02),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: height * 0.01,
              ),
              child: Center(
                child: Container(
                  width: 380,
                  height: 370,
                  decoration: CustomTheme.customBoxDecoration()
                      .copyWith(color: CustomTheme.accentColor),
                  child: Image.asset(
                    'assets/icons/music_filter.png',
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: width * 0.0, top: height * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    musicFile.fileName,
                    style: CustomTheme.textTheme(context).bodyMedium,
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  Text(
                    musicFile.createdAt != null
                        ? '${musicFile.createdAt!.day}/${musicFile.createdAt!.month}/${musicFile.createdAt!.year}'
                        : 'No date available',
                    style: CustomTheme.textTheme(context)
                        .bodyMedium
                        ?.copyWith(color: Colors.grey),
                  ),
                  SizedBox(height: height * 0.02),
                  Slider(
                    value: (playerState.position ?? Duration.zero)
                        .inSeconds
                        .toDouble(),
                    min: 0,
                    max: (playerState.duration ?? Duration.zero)
                        .inSeconds
                        .toDouble(),
                    onChanged: (value) {
                      ref
                          .read(musicPlayerProvider(musicFile).notifier)
                          .seek(Duration(seconds: value.toInt()));
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatDuration(playerState.position),
                          style: CustomTheme.textTheme(context)
                              .bodySmall
                              ?.copyWith(color: Colors.grey),
                        ),
                        Text(
                          _formatDuration(playerState.duration),
                          style: CustomTheme.textTheme(context)
                              .bodySmall
                              ?.copyWith(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(
                          playerState.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                          color: Colors.white,
                          size: 48,
                        ),
                        onPressed: () {
                          ref
                              .read(musicPlayerProvider(musicFile).notifier)
                              .togglePlay();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
