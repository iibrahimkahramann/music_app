import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/config/theme/custom_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/db/app_database.dart';
import 'package:music_app/library/provider/library_provider.dart';
import 'package:music_app/config/providers/music_player_provider.dart';
import 'package:music_app/playlist_detail/provider/playlist_detail_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../music_bar/view/music_bar.dart';

class PlaylistDetailView extends ConsumerStatefulWidget {
  final String? playlistId;

  const PlaylistDetailView({super.key, required this.playlistId});

  @override
  ConsumerState<PlaylistDetailView> createState() => _PlaylistDetailViewState();
}

class _PlaylistDetailViewState extends ConsumerState<PlaylistDetailView> {
  @override
  Widget build(BuildContext context) {
    final AppDatabase db = AppDatabase();
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final playlistDetailAsync =
        ref.watch(playlistDetailProvider(widget.playlistId!));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomTheme.backgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            context.go('/playlists');
          },
        ),
        title: Padding(
          padding: EdgeInsets.only(left: width * 0.1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Playlist Detail'.tr(),
                style: CustomTheme.textTheme(context)
                    .bodyMedium
                    ?.copyWith(color: Colors.white),
              ),
              GestureDetector(
                onTap: () {
                  context.go(
                      '/playlist-add-music?playlistId=${widget.playlistId}');
                },
                child: Image.asset(
                  'assets/icons/add.png',
                  height: height * 0.029,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          playlistDetailAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text('Error: $error')),
            data: (data) => SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: width * 0.02, vertical: height * 0.02),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: width * 0.5,
                        height: width * 0.5,
                        decoration: CustomTheme.customBoxDecoration(),
                        child: data.$1.imagePath != null &&
                                data.$1.imagePath!.isNotEmpty &&
                                File(data.$1.imagePath!).existsSync()
                            ? Image.file(File(data.$1.imagePath!),
                                fit: BoxFit.cover)
                            : Icon(
                                Icons.queue_music_outlined,
                                color: Colors.white,
                                size: width * 0.09,
                              ),
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    Text(
                      data.$1.fileName,
                      style: CustomTheme.textTheme(context).bodyLarge,
                    ),
                    SizedBox(height: height * 0.001),
                    Text(
                      '${data.$2.length} ${'Songs'.tr()}',
                      style: CustomTheme.textTheme(context).bodySmall,
                    ),
                    SizedBox(height: height * 0.02),
                    data.$2.isEmpty
                        ? Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    context.go(
                                        '/playlist-add-music?playlistId=${widget.playlistId}');
                                  },
                                  child: Container(
                                    width: width * 0.6,
                                    height: height * 0.06,
                                    decoration: BoxDecoration(
                                      color: CustomTheme.accentColor,
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Add Music to Playlist'.tr(),
                                        style: CustomTheme.textTheme(context)
                                            .bodyMedium,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: height * 0.03,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: width * 0.15,
                                      right: width * 0.15,
                                      top: height * 0.0),
                                  child: Text(
                                    'No Music Yet. Add Music by Pressing the Add Music Button'
                                        .tr(),
                                    style: CustomTheme.textTheme(context)
                                        .bodySmall,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Column(
                            children: data.$2
                                .map((music) => GestureDetector(
                                      onTap: () {
                                        ref
                                            .read(selectedMusicFileProvider
                                                .notifier)
                                            .state = music;
                                        final playerNotifier =
                                            ref.read(musicPlayerProvider((
                                          musicFile: music,
                                          onPrevious: null,
                                          onNext: null,
                                        )).notifier);
                                        playerNotifier.togglePlay();
                                        final currentIndex =
                                            data.$2.indexOf(music);
                                        context.go('/music-detail', extra: {
                                          'musicFile': music,
                                          'musicFiles': data.$2,
                                          'currentIndex': currentIndex,
                                          'onPrevious': currentIndex > 0
                                              ? () {
                                                  print(
                                                      'Önceki şarkı callback ayarlandı');
                                                  context.go('/music-detail',
                                                      extra: {
                                                        'musicFile': data.$2[
                                                            currentIndex - 1],
                                                        'musicFiles': data.$2,
                                                        'currentIndex':
                                                            currentIndex - 1,
                                                      });
                                                }
                                              : null,
                                          'onNext': currentIndex <
                                                  data.$2.length - 1
                                              ? () {
                                                  print(
                                                      'Sonraki şarkı callback ayarlandı');
                                                  context.go('/music-detail',
                                                      extra: {
                                                        'musicFile': data.$2[
                                                            currentIndex + 1],
                                                        'musicFiles': data.$2,
                                                        'currentIndex':
                                                            currentIndex + 1,
                                                      });
                                                }
                                              : null,
                                        });
                                      },
                                      child: Stack(
                                        children: [
                                          Container(
                                            width: width,
                                            height: height * 0.1,
                                            margin: EdgeInsets.only(
                                                bottom: height * 0.015),
                                            decoration: CustomTheme
                                                .customBoxDecoration(),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                width * 0.03,
                                                height * 0.013,
                                                0,
                                                height * 0.013),
                                            child: Container(
                                              width: width * 0.16,
                                              height: width * 0.16,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Icon(
                                                  Icons.music_note_rounded,
                                                  size: width * 0.1),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                width * 0.22,
                                                height * 0.022,
                                                0,
                                                height * 0.022),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      music.fileName.length > 20
                                                          ? '${music.fileName.substring(0, 20)}...'
                                                          : music.fileName,
                                                      style:
                                                          CustomTheme.textTheme(
                                                                  context)
                                                              .bodyMedium,
                                                    ),
                                                    SizedBox(
                                                        height: height * 0.002),
                                                    Text(
                                                      music.createdAt != null
                                                          ? '${music.createdAt!.day}/${music.createdAt!.month}/${music.createdAt!.year}'
                                                          : 'Tarih bilgisi yok',
                                                      style:
                                                          CustomTheme.textTheme(
                                                                  context)
                                                              .bodySmall,
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(width: width * 0.12),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      right: width * 0.045,
                                                      top: height * 0.001),
                                                  child: Row(
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          showModalBottomSheet(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return SizedBox(
                                                                height: height *
                                                                    0.3,
                                                                child: Column(
                                                                  children: <Widget>[
                                                                    ListTile(
                                                                      leading: Icon(
                                                                          Icons
                                                                              .music_note_sharp),
                                                                      title:
                                                                          Text(
                                                                        music.fileName.length >
                                                                                30
                                                                            ? '${music.fileName.substring(0, 30)}...'
                                                                            : music.fileName,
                                                                        style: CustomTheme.textTheme(context)
                                                                            .bodyMedium,
                                                                      ),
                                                                    ),
                                                                    ListTile(
                                                                      leading: Icon(
                                                                          Icons
                                                                              .share),
                                                                      title:
                                                                          Text(
                                                                        'Share'
                                                                            .tr(),
                                                                        style: CustomTheme.textTheme(context)
                                                                            .bodyMedium,
                                                                      ),
                                                                      onTap:
                                                                          () {
                                                                        Share.share(
                                                                            'Check out this music: ${music.fileName}');
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                    ),
                                                                    ListTile(
                                                                      leading: Icon(
                                                                          Icons
                                                                              .delete),
                                                                      title:
                                                                          Text(
                                                                        'Delete'
                                                                            .tr(),
                                                                        style: CustomTheme.textTheme(context)
                                                                            .bodyMedium,
                                                                      ),
                                                                      onTap:
                                                                          () async {
                                                                        Navigator.pop(
                                                                            context);
                                                                        final shouldDelete =
                                                                            await showDialog<bool>(
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (BuildContext context) {
                                                                            return CupertinoAlertDialog(
                                                                              title: Text(
                                                                                'Delete Music File'.tr(),
                                                                              ),
                                                                              content: Text(
                                                                                'Are you sure you want to delete this music file from the playlist?'.tr(),
                                                                              ),
                                                                              actions: <Widget>[
                                                                                TextButton(
                                                                                  onPressed: () {
                                                                                    Navigator.pop(context, false);
                                                                                  },
                                                                                  child: Text(
                                                                                    'No'.tr(),
                                                                                  ),
                                                                                ),
                                                                                CupertinoDialogAction(
                                                                                  isDestructiveAction: true,
                                                                                  child: Text('Delete'.tr()),
                                                                                  onPressed: () => Navigator.of(context).pop(true),
                                                                                ),
                                                                              ],
                                                                            );
                                                                          },
                                                                        );

                                                                        if (shouldDelete ??
                                                                            false) {
                                                                          await db
                                                                              .deleteMusicFromPlaylist(
                                                                            int.parse(widget.playlistId!),
                                                                            music.id,
                                                                          );
                                                                          ref.invalidate(
                                                                              playlistMusicProvider);
                                                                        }
                                                                      },
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                            },
                                                          );
                                                        },
                                                        child: Icon(
                                                          Icons
                                                              .more_vert_rounded,
                                                          size: width * 0.07,
                                                          color: CustomTheme
                                                              .regularColor,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ))
                                .toList(),
                          ),
                  ],
                ),
              ),
            ),
          ),
          const Align(
            alignment: Alignment.bottomCenter,
            child: MusicBar(),
          ),
        ],
      ),
    );
  }
}
