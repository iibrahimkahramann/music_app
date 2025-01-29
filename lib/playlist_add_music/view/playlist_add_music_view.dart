import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/config/theme/custom_theme.dart';
import 'package:music_app/db/app_database.dart';
import 'package:music_app/playlist_detail/provider/playlist_detail_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlaylistAddMusicView extends ConsumerStatefulWidget {
  final int musicId; // Eklenmek istenen müzik ID'si

  const PlaylistAddMusicView({super.key, required this.musicId});

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
    await db.addMusicToPlaylist(playlistId, widget.musicId);
    ref.read(playlistRefreshProvider.notifier).state++;
    if (context.mounted) {
      context.go('/library');
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
            context.go('/library');
          },
        ),
        title: Padding(
          padding: EdgeInsets.only(left: width * 0.19),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Select Playlist',
                style: CustomTheme.textTheme(context)
                    .bodyMedium
                    ?.copyWith(color: Colors.white),
              ),
              Image.asset(
                'assets/icons/add.png',
                height: height * 0.029,
              ),
            ],
          ),
        ),
      ),
      body: playlists.isEmpty
          ? const Center(child: Text('Henüz çalma listesi yok'))
          : ListView.builder(
              itemCount: playlists.length,
              itemBuilder: (context, index) {
                final playlist = playlists[index];
                return ListTile(
                  // leading: playlist.imagePath != null
                  //     ? Image.asset(playlist.imagePath!, width: 50, height: 50)
                  //     : const Icon(Icons.music_note, color: Colors.white),
                  title: Text(playlist.fileName,
                      style: TextStyle(color: Colors.white)),
                  onTap: () => _addMusicToPlaylist(playlist.id),
                );
              },
            ),
    );
  }
}
