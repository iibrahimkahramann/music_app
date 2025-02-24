import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/config/theme/custom_theme.dart';
import 'package:music_app/db/app_database.dart';
import 'package:music_app/playlist_detail/provider/playlist_detail_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlaylistAddMusicView extends ConsumerStatefulWidget {
  final int? musicId; // Opsiyonel olarak değiştirildi
  final String? playlistId; // Yeni eklendi

  const PlaylistAddMusicView({super.key, this.musicId, this.playlistId});

  @override
  ConsumerState<PlaylistAddMusicView> createState() =>
      _PlaylistAddMusicViewState();
}

class _PlaylistAddMusicViewState extends ConsumerState<PlaylistAddMusicView> {
  late AppDatabase db;
  List<PlaylistFile> playlists = [];

  @override
  void initState() {
    super.initState();
    db = AppDatabase();
    _fetchPlaylists();
  }

  Future<void> _fetchPlaylists() async {
    final data = await db.getAllPlaylistFiles();
    setState(() {
      playlists = data;
    });
  }

  Future<void> _addMusicToPlaylist(int playlistId) async {
    if (widget.musicId != null) {
      await db.addMusicToPlaylist(playlistId, widget.musicId!);
    }
    ref.read(playlistRefreshProvider.notifier).state++;
    if (context.mounted) {
      if (widget.playlistId != null) {
        context.go('/playlist-detail/${widget.playlistId}');
      } else {
        context.go('/library');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomTheme.backgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (widget.playlistId != null) {
              context.go('/playlist-detail/${widget.playlistId}');
            } else {
              context.go('/library');
            }
          },
        ),
        title: Padding(
          padding: EdgeInsets.only(left: width * 0.25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Select'.tr(),
                style: CustomTheme.textTheme(context)
                    .bodyMedium
                    ?.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
      body: widget.musicId == null
          ? FutureBuilder<List<MusicFile>>(
              future: db.getAllMusicFiles(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final musicFiles = snapshot.data!;
                return ListView.builder(
                  itemCount: musicFiles.length,
                  itemBuilder: (context, index) {
                    final music = musicFiles[index];
                    return Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: width * 0.02, vertical: height * 0.007),
                      decoration: CustomTheme.customBoxDecoration(),
                      child: ListTile(
                        leading: Container(
                          width: width * 0.1,
                          height: width * 0.1,
                          decoration: BoxDecoration(
                            color: CustomTheme.accentColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.music_note,
                            color: Colors.white,
                            size: width * 0.06,
                          ),
                        ),
                        title: Text(
                          music.fileName,
                          style: CustomTheme.textTheme(context).bodyMedium,
                        ),
                        trailing: Icon(
                          Icons.add_circle_outline,
                          color: CustomTheme.accentColor,
                          size: width * 0.07,
                        ),
                        onTap: () async {
                          if (widget.playlistId != null) {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: CustomTheme.accentColor,
                                  ),
                                );
                              },
                            );

                            await db.addMusicToPlaylist(
                                int.parse(widget.playlistId!), music.id);
                            ref.read(playlistRefreshProvider.notifier).state++;

                            if (context.mounted) {
                              // Yükleniyor göstergesini kapat
                              Navigator.pop(context);
                              // Başarılı mesajı göster
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Music added to playlist'.tr(),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: CustomTheme.accentColor,
                                  duration: Duration(seconds: 2),
                                ),
                              );
                              // Playlist detay sayfasına dön
                              context
                                  .go('/playlist-detail/${widget.playlistId}');
                            }
                          }
                        },
                      ),
                    );
                  },
                );
              },
            )
          : playlists.isEmpty
              ? Center(
                  child: Text(
                    'No Playlists Yet. Add Playlists by Pressing the Add Playlists Button'
                        .tr(),
                    style: CustomTheme.textTheme(context).bodyLarge,
                  ),
                )
              : ListView.builder(
                  itemCount: playlists.length,
                  itemBuilder: (context, index) {
                    final playlist = playlists[index];
                    return Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: width * 0.02, vertical: height * 0.007),
                      decoration: CustomTheme.customBoxDecoration(),
                      child: ListTile(
                        leading: Container(
                          width: width * 0.1,
                          height: width * 0.1,
                          decoration: BoxDecoration(
                            color: CustomTheme.accentColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.queue_music,
                            color: Colors.white,
                            size: width * 0.06,
                          ),
                        ),
                        title: Text(
                          playlist.fileName,
                          style: CustomTheme.textTheme(context).bodyMedium,
                        ),
                        trailing: Icon(
                          Icons.add_circle_outline,
                          color: CustomTheme.accentColor,
                          size: width * 0.07,
                        ),
                        onTap: () async {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return Center(
                                child: CircularProgressIndicator(
                                  color: CustomTheme.accentColor,
                                ),
                              );
                            },
                          );

                          await _addMusicToPlaylist(playlist.id);

                          if (context.mounted) {
                            Navigator.pop(context);

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Music added to playlist'.tr(),
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: CustomTheme.accentColor,
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
