import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/config/theme/custom_theme.dart';
import 'package:music_app/db/app_database.dart';
import 'package:music_app/music_detail/provider/music_player_provider.dart';
import 'package:music_app/services/navigation_service.dart';

class MusicDetailView extends ConsumerWidget {
  final MusicFile musicFile;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  const MusicDetailView({
    super.key,
    required this.musicFile,
    this.onPrevious,
    this.onNext,
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
    NavigationService().setContext(context);
    NavigationService().setContainer(ProviderContainer());

    final playerState = ref.watch(musicPlayerProvider((
      musicFile: musicFile,
      onPrevious: onPrevious,
      onNext: onNext,
    )));
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
                      .copyWith(color: CustomTheme.secondaryColor),
                  child: Icon(Icons.music_note_rounded, size: width * 0.3),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: width * 0.0, top: height * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: width * 0.03),
                    child: Text(
                      musicFile.fileName,
                      style: CustomTheme.textTheme(context).bodyMedium,
                    ),
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: width * 0.03),
                    child: Text(
                      musicFile.createdAt != null
                          ? '${musicFile.createdAt!.day}/${musicFile.createdAt!.month}/${musicFile.createdAt!.year}'
                          : 'No date available',
                      style: CustomTheme.textTheme(context)
                          .bodyMedium
                          ?.copyWith(color: Colors.grey),
                    ),
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
                          .read(musicPlayerProvider((
                            musicFile: musicFile,
                            onPrevious: onPrevious,
                            onNext: onNext,
                          )).notifier)
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
                          playerState.isLooping
                              ? Icons.repeat_one
                              : Icons.repeat,
                          color: playerState.isLooping
                              ? CustomTheme.accentColor
                              : Colors.white,
                          size: width * 0.09,
                        ),
                        onPressed: () {
                          ref
                              .read(musicPlayerProvider((
                                musicFile: musicFile,
                                onPrevious: onPrevious,
                                onNext: onNext,
                              )).notifier)
                              .toggleLoop();
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.skip_previous,
                          color: Colors.white,
                          size: width * 0.13,
                        ),
                        onPressed: onPrevious != null
                            ? () {
                                ref
                                    .read(musicPlayerProvider(
                                      (
                                        musicFile: musicFile,
                                        onPrevious: onPrevious,
                                        onNext: onNext,
                                      ),
                                    ).notifier)
                                    .previousTrack();
                              }
                            : null,
                      ),
                      IconButton(
                        icon: Container(
                          decoration: BoxDecoration(
                            color: CustomTheme.accentColor,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Icon(
                            playerState.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow,
                            color: Colors.white,
                            size: width * 0.18,
                          ),
                        ),
                        onPressed: () {
                          ref
                              .read(musicPlayerProvider((
                                musicFile: musicFile,
                                onPrevious: onPrevious,
                                onNext: onNext,
                              )).notifier)
                              .togglePlay();
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.skip_next,
                          color: Colors.white,
                          size: width * 0.13,
                        ),
                        onPressed: onNext != null
                            ? () {
                                ref
                                    .read(musicPlayerProvider((
                                      musicFile: musicFile,
                                      onPrevious: onPrevious,
                                      onNext: onNext,
                                    )).notifier)
                                    .nextTrack();
                              }
                            : null,
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.volume_up,
                          color: Colors.white,
                          size: width * 0.08,
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => VolumeControlDialog(
                              musicFile: musicFile,
                              onPrevious: onPrevious,
                              onNext: onNext,
                            ),
                          );
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

class VolumeControlDialog extends ConsumerStatefulWidget {
  final MusicFile musicFile;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  const VolumeControlDialog({
    super.key,
    required this.musicFile,
    this.onPrevious,
    this.onNext,
  });

  @override
  ConsumerState<VolumeControlDialog> createState() =>
      _VolumeControlDialogState();
}

class _VolumeControlDialogState extends ConsumerState<VolumeControlDialog> {
  double _volume = 1.0;

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text('Ses Seviyesi'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CupertinoSlider(
            value: _volume,
            min: 0.0,
            max: 1.0,
            onChanged: (value) {
              setState(() {
                _volume = value;
              });
              ref
                  .read(musicPlayerProvider((
                    musicFile: widget.musicFile,
                    onPrevious: widget.onPrevious,
                    onNext: widget.onNext,
                  )).notifier)
                  .setVolume(value);
            },
          ),
        ],
      ),
      actions: [
        CupertinoDialogAction(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Kapat'),
        ),
      ],
    );
  }
}
