import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/bar/appbar/app_bar.dart';
import 'package:music_app/bar/navbar/nav_bar.dart';
import 'package:music_app/config/theme/custom_theme.dart';
import 'package:music_app/playlists/controller/playlist_controller.dart';
import 'package:music_app/playlists/provider/playlist_provider.dart';

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
                    padding: EdgeInsets.only(left: width * 0.65),
                    child: GestureDetector(
                      onTap: () =>
                          showAddPlaylistDialog(context, playlistNotifier),
                      child: Image.asset(
                        'assets/icons/add.png',
                        height: height * 0.035,
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
                      child: Padding(
                        padding: EdgeInsets.only(top: height * 0.3),
                        child: Text(
                          'Boş',
                          style: CustomTheme.textTheme(context).bodyLarge,
                        ),
                      ),
                    )
                  : Column(
                      children: playlists.map((playlist) {
                        return GestureDetector(
                          onTap: () =>
                              context.go('/playlist-detail/${playlist.id}'),
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
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          playlist.fileName,
                                          style: CustomTheme.textTheme(context)
                                              .bodyMedium,
                                        ),
                                        SizedBox(
                                          height: height * 0.002,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomNavBar(currentLocation: '/playlists'),
    );
  }
}
