import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/config/theme/custom_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/playlist_detail/provider/playlist_detail_provider.dart';

class PlaylistDetailView extends ConsumerStatefulWidget {
  final String? playlistId; // Parametre ekledik

  const PlaylistDetailView({super.key, required this.playlistId});

  @override
  ConsumerState<PlaylistDetailView> createState() => _PlaylistDetailViewState();
}

class _PlaylistDetailViewState extends ConsumerState<PlaylistDetailView> {
  @override
  Widget build(BuildContext context) {
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
          padding: EdgeInsets.only(left: width * 0.19),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Playlist Detail',
                style: CustomTheme.textTheme(context)
                    .bodyMedium
                    ?.copyWith(color: Colors.white),
              ),
              Image.asset(
                'assets/icons/search.png',
                height: height * 0.029,
              ),
            ],
          ),
        ),
      ),
      body: playlistDetailAsync.when(
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
                    width: 220,
                    height: 220,
                    decoration: CustomTheme.customBoxDecoration(),
                    child: Image.asset(
                      'assets/icons/music_filter.png',
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: height * 0.02),
                Text(
                  data.$1.fileName,
                  style: CustomTheme.textTheme(context).bodyLarge,
                ),
                SizedBox(height: height * 0.02),
                ...data.$2
                    .map((music) => Stack(
                          children: [
                            Container(
                              width: width,
                              height: height * 0.1,
                              margin: EdgeInsets.only(bottom: height * 0.015),
                              decoration: CustomTheme.customBoxDecoration(),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(width * 0.03,
                                  height * 0.013, 0, height * 0.013),
                              child: Container(
                                width: width * 0.16,
                                height: width * 0.16,
                                decoration: BoxDecoration(
                                  color: CustomTheme.accentColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(width * 0.22,
                                  height * 0.022, 0, height * 0.022),
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        music.fileName.length > 25
                                            ? '${music.fileName.substring(0, 25)}...'
                                            : music.fileName,
                                        style: CustomTheme.textTheme(context)
                                            .bodyMedium,
                                      ),
                                      SizedBox(height: height * 0.002),
                                      Text(
                                        music.createdAt?.toString() ??
                                            'No date',
                                        style: CustomTheme.textTheme(context)
                                            .bodySmall,
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: width * 0.12),
                                ],
                              ),
                            ),
                          ],
                        ))
                    .toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
