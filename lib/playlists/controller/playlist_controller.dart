import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:music_app/playlists/provider/playlist_provider.dart';

void showAddPlaylistDialog(
    BuildContext context, PlaylistNotifier playlistNotifier) {
  final TextEditingController controller = TextEditingController();

  if (Platform.isIOS) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text('Add to Playlist'),
          content: Column(
            children: <Widget>[
              Text('Do you want to add this song to your playlist?'),
              CupertinoTextField(
                controller: controller,
                placeholder: 'Playlist name',
              ),
            ],
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: Text('Create'),
              onPressed: () {
                final playlistName = controller.text.trim();
                if (playlistName.isNotEmpty) {
                  playlistNotifier.addPlaylist(playlistName);
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  } else {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add to Playlist'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Playlist name'),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Create'),
              onPressed: () {
                final playlistName = controller.text.trim();
                if (playlistName.isNotEmpty) {
                  playlistNotifier.addPlaylist(playlistName);
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
