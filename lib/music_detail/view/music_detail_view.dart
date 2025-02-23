import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/config/theme/custom_theme.dart';
import 'package:music_app/music_player_provider.dart';
import 'package:music_app/db/app_database.dart';
import 'package:share_plus/share_plus.dart';

class MusicDetailView extends ConsumerWidget {
  final MusicFile musicFile;
  final List<MusicFile> musicFiles;
  final int currentIndex;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  const MusicDetailView({
    Key? key,
    required this.musicFile,
    required this.musicFiles,
    required this.currentIndex,
    this.onPrevious,
    this.onNext,
  }) : super(key: key);

  String _formatDuration(Duration? duration) {
    if (duration == null) return '--:--';
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '$twoDigitMinutes:$twoDigitSeconds';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Map<String, dynamic> data =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final onPrevious = data['onPrevious'] as VoidCallback?;
    final onNext = data['onNext'] as VoidCallback?;

    final player = ref.watch(musicPlayerProvider((
      musicFile: musicFile,
      onPrevious: onPrevious,
      onNext: onNext,
    )));
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

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
                  width: width * 0.9,
                  height: height * 0.4,
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
                          : 'Tarih bilgisi yok',
                      style: CustomTheme.textTheme(context)
                          .bodyMedium
                          ?.copyWith(color: Colors.grey),
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                  Slider(
                    value: (player.position).inSeconds.toDouble(),
                    min: 0,
                    max: player.duration.inSeconds.toDouble(),
                    onChanged: (value) {
                      ref
                          .read(musicPlayerProvider((
                            musicFile: musicFile,
                            onNext: onNext,
                            onPrevious: onPrevious
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
                          _formatDuration(player.position),
                          style: CustomTheme.textTheme(context)
                              .bodySmall
                              ?.copyWith(color: Colors.grey),
                        ),
                        Text(
                          _formatDuration(player.duration),
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
                      // IconButton(
                      //   icon: Icon(Icons.skip_previous),
                      //   onPressed: onPrevious != null
                      //       ? () {
                      //           print('Önceki şarkı butonuna basıldı');
                      //           onPrevious();
                      //           ref
                      //               .read(musicPlayerProvider((
                      //                 musicFile: musicFile,
                      //                 onPrevious: onPrevious,
                      //                 onNext: onNext,
                      //               )).notifier)
                      //               .previousTrack();
                      //         }
                      //       : null,
                      // ),
                      IconButton(
                        icon: Icon(
                          player.isLooping ? Icons.repeat_one : Icons.repeat,
                          color: player.isLooping
                              ? CustomTheme.accentColor
                              : Colors.white,
                          size: width * 0.09,
                        ),
                        onPressed: () {
                          ref
                              .read(musicPlayerProvider((
                                musicFile: musicFile,
                                onNext: onNext,
                                onPrevious: onPrevious
                              )).notifier)
                              .toggleLoop();
                        },
                      ),
                      SizedBox(width: width * 0.04),
                      IconButton(
                        icon: Icon(
                            player.isPlaying
                                ? Icons.pause_circle_rounded
                                : Icons.play_circle_rounded,
                            size: height * 0.07),
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
                      SizedBox(width: width * 0.04),
                      IconButton(
                        icon:
                            Icon(Icons.ios_share_rounded, size: height * 0.05),
                        onPressed: () {
                          Share.share(
                              'Check out this music: ${musicFile.fileName}');
                        },
                      ),
                      // IconButton(
                      //   icon: Icon(Icons.skip_next),
                      //   onPressed: onNext != null
                      //       ? () {
                      //           print('Sonraki şarkı butonuna basıldı');
                      //           onNext();
                      //           ref
                      //               .read(musicPlayerProvider((
                      //                 musicFile: musicFile,
                      //                 onPrevious: onPrevious,
                      //                 onNext: onNext,
                      //               )).notifier)
                      //               .nextTrack();
                      //         }
                      //       : null,
                      // ),
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

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:music_app/config/theme/custom_theme.dart';
// import 'package:music_app/music_player_provider.dart';
// import 'package:music_app/db/app_database.dart';
// import 'package:music_app/services/navigation_service.dart';

// class MusicDetailView extends ConsumerWidget {
//   final MusicFile musicFile;
//   final List<MusicFile> musicFiles;
//   final int currentIndex;
//   final VoidCallback? onPrevious;
//   final VoidCallback? onNext;

//   const MusicDetailView({
//     Key? key,
//     required this.musicFile,
//     required this.musicFiles,
//     required this.currentIndex,
//     this.onPrevious,
//     this.onNext,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final player = ref.watch(musicPlayerProvider((
//       musicFile: musicFile,
//       onPrevious: onPrevious,
//       onNext: onNext,
//     )));
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: CustomTheme.backgroundColor,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () {
//             context.go('/library');
//           },
//         ),
//         title: Padding(
//           padding: EdgeInsets.only(left: width * 0.19),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Music Detail',
//                 style: CustomTheme.textTheme(context)
//                     .bodyMedium
//                     ?.copyWith(color: Colors.white),
//               ),
//             ],
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: EdgeInsets.symmetric(
//             horizontal: width * 0.02, vertical: height * 0.02),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: EdgeInsets.only(
//                 top: height * 0.01,
//               ),
//               child: Center(
//                 child: Container(
//                   width: 380,
//                   height: 370,
//                   decoration: CustomTheme.customBoxDecoration()
//                       .copyWith(color: CustomTheme.secondaryColor),
//                   child: Icon(Icons.music_note_rounded, size: width * 0.3),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.only(left: width * 0.0, top: height * 0.04),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: EdgeInsets.only(left: width * 0.03),
//                     child: Text(
//                       musicFile.fileName,
//                       style: CustomTheme.textTheme(context).bodyMedium,
//                     ),
//                   ),
//                   SizedBox(
//                     height: height * 0.01,
//                   ),
//                   Padding(
//                     padding: EdgeInsets.only(left: width * 0.03),
//                     child: Text(
//                       musicFile.createdAt != null
//                           ? '${musicFile.createdAt!.day}/${musicFile.createdAt!.month}/${musicFile.createdAt!.year}'
//                           : 'Tarih bilgisi yok',
//                       style: CustomTheme.textTheme(context)
//                           .bodyMedium
//                           ?.copyWith(color: Colors.grey),
//                     ),
//                   ),
//                   SizedBox(height: height * 0.02),
//                   Slider(
//                     value:
//                         0.0, // TODO: musicPlayerState.position'ı buraya ekleyin
//                     min: 0,
//                     max:
//                         100.0, // TODO: musicPlayerState.duration'ı buraya ekleyin
//                     onChanged: (value) {
//                       // TODO: musicPlayerState.seek'ı buraya ekleyin
//                     },
//                   ),
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: width * 0.02),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           _formatDuration(Duration(seconds: 0)),
//                           style: CustomTheme.textTheme(context)
//                               .bodySmall
//                               ?.copyWith(color: Colors.grey),
//                         ),
//                         Text(
//                           _formatDuration(Duration(seconds: 100)),
//                           style: CustomTheme.textTheme(context)
//                               .bodySmall
//                               ?.copyWith(color: Colors.grey),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       IconButton(
//                         icon: Icon(Icons.skip_previous),
//                         onPressed: onPrevious != null
//                             ? () {
//                                 onPrevious?.call();
//                                 ref
//                                     .read(musicPlayerProvider(
//                                       (
//                                         musicFile: musicFile,
//                                         onPrevious: onPrevious,
//                                         onNext: onNext,
//                                       ),
//                                     ).notifier)
//                                     .previousTrack();
//                               }
//                             : null,
//                       ),
//                       IconButton(
//                         icon: Icon(
//                             player.isPlaying ? Icons.pause : Icons.play_arrow),
//                         onPressed: () {
//                           ref
//                               .read(musicPlayerProvider((
//                                 musicFile: musicFile,
//                                 onPrevious: onPrevious,
//                                 onNext: onNext,
//                               )).notifier)
//                               .togglePlay();
//                         },
//                       ),
//                       IconButton(
//                         icon: Icon(Icons.skip_next),
//                         onPressed: onNext != null
//                             ? () {
//                                 onNext?.call();
//                                 ref
//                                     .read(musicPlayerProvider((
//                                       musicFile: musicFile,
//                                       onPrevious: onPrevious,
//                                       onNext: onNext,
//                                     )).notifier)
//                                     .nextTrack();
//                               }
//                             : null,
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   String _formatDuration(Duration? duration) {
//     if (duration == null) return '--:--';
//     String twoDigits(int n) => n.toString().padLeft(2, '0');
//     String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
//     String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
//     return '$twoDigitMinutes:$twoDigitSeconds';
//   }
// }
