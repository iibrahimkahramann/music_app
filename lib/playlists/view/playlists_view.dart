import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:music_app/bar/appbar/app_bar.dart';
import 'package:music_app/bar/navbar/nav_bar.dart';
import 'package:music_app/config/theme/custom_theme.dart';
import 'package:music_app/playlists/controller/playlist_controller.dart';
import 'package:music_app/playlists/provider/playlist_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/cupertino.dart';

class PlaylistsView extends ConsumerWidget {
  const PlaylistsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playlists = ref.watch(playlistProvider);
    final playlistNotifier = ref.read(playlistProvider.notifier);

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.02, vertical: height * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Playlist',
                    style: CustomTheme.textTheme(context).bodyLarge,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: width * 0.66),
                    child: GestureDetector(
                      onTap: () =>
                          showAddPlaylistDialog(context, playlistNotifier),
                      child: Image.asset(
                        'assets/icons/add.png',
                        height: height * 0.029,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.015,
              ),
              playlists.isEmpty
                  ? Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Lottie.asset('assets/json/not_music.json',
                              width: width * 0.6),
                          Padding(
                            padding: EdgeInsets.only(
                                left: width * 0.2,
                                right: width * 0.2,
                                top: height * 0.0),
                            child: Text(
                              'No Music Yet. Add Music by Pressing the Add Music Button',
                              style: CustomTheme.textTheme(context).bodySmall,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            height: height * 0.03,
                          ),
                          GestureDetector(
                            onTap: () => showAddPlaylistDialog(
                                context, playlistNotifier),
                            child: Container(
                              width: width * 0.4,
                              height: height * 0.05,
                              decoration: BoxDecoration(
                                color: CustomTheme.accentColor,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Center(
                                  child: Text(
                                'Add Music',
                                style:
                                    CustomTheme.textTheme(context).bodyMedium,
                              )),
                            ),
                          )
                        ],
                      ),
                    )
                  : Column(
                      children: playlists.map(
                        (playlist) {
                          return GestureDetector(
                            onTap: () {
                              context.go('/playlist-detail/${playlist.id}');
                            },
                            child: Stack(
                              children: [
                                Container(
                                  width: width,
                                  height: height * 0.115,
                                  color: Colors.black,
                                ),
                                Container(
                                  width: width * 0.22,
                                  height: height * 0.1,
                                  decoration: CustomTheme.customBoxDecoration(),
                                  child: playlist.imagePath != null &&
                                          playlist.imagePath!.isNotEmpty &&
                                          File(playlist.imagePath!).existsSync()
                                      ? Image.file(File(playlist.imagePath!),
                                          fit: BoxFit.cover)
                                      : Icon(
                                          Icons.queue_music_outlined,
                                          color: Colors.white,
                                          size: width * 0.08,
                                        ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(width * 0.25,
                                      height * 0.022, 0, height * 0.022),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            playlist.fileName,
                                            style:
                                                CustomTheme.textTheme(context)
                                                    .bodyMedium,
                                          ),
                                          SizedBox(
                                            height: height * 0.002,
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            right: width * 0.074,
                                            top: height * 0.0125),
                                        child: GestureDetector(
                                          onTap: () {
                                            showModalBottomSheet(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return SizedBox(
                                                  height: height * 0.3,
                                                  child: Column(
                                                    children: <Widget>[
                                                      ListTile(
                                                        leading: Icon(Icons
                                                            .music_note_sharp),
                                                        title: Text(
                                                          playlist.fileName
                                                                      .length >
                                                                  25
                                                              ? '${playlist.fileName.substring(0, 25)}...'
                                                              : playlist
                                                                  .fileName,
                                                          style: CustomTheme
                                                                  .textTheme(
                                                                      context)
                                                              .bodyMedium,
                                                        ),
                                                      ),
                                                      ListTile(
                                                        leading:
                                                            Icon(Icons.share),
                                                        title: Text(
                                                          'Paylaş',
                                                          style: CustomTheme
                                                                  .textTheme(
                                                                      context)
                                                              .bodyMedium,
                                                        ),
                                                        onTap: () {
                                                          Share.share(
                                                              'Check out this playlist: ${playlist.fileName}');
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      ),
                                                      ListTile(
                                                        leading:
                                                            Icon(Icons.delete),
                                                        title: Text(
                                                          'Sil',
                                                          style: CustomTheme
                                                                  .textTheme(
                                                                      context)
                                                              .bodyMedium,
                                                        ),
                                                        onTap: () async {
                                                          Navigator.pop(
                                                              context);
                                                          final shouldDelete =
                                                              await showDialog<
                                                                  bool>(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return CupertinoAlertDialog(
                                                                title: Text(
                                                                    'Playlist\'i Sil'),
                                                                content: Text(
                                                                    'Bu playlist\'i silmek istediğinizden emin misiniz?'),
                                                                actions: <Widget>[
                                                                  CupertinoDialogAction(
                                                                    isDefaultAction:
                                                                        true,
                                                                    child: Text(
                                                                        'İptal'),
                                                                    onPressed: () =>
                                                                        Navigator.of(context)
                                                                            .pop(false),
                                                                  ),
                                                                  CupertinoDialogAction(
                                                                    isDestructiveAction:
                                                                        true,
                                                                    child: Text(
                                                                        'Sil'),
                                                                    onPressed: () =>
                                                                        Navigator.of(context)
                                                                            .pop(true),
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          );

                                                          if (shouldDelete ==
                                                              true) {
                                                            await playlistNotifier
                                                                .deletePlaylist(
                                                                    playlist
                                                                        .id);
                                                          }
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                          child: Image.asset(
                                            'assets/icons/menu.png',
                                            height: height * 0.024,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ).toList(),
                    ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomNavBar(currentLocation: '/playlists'),
    );
  }
}
