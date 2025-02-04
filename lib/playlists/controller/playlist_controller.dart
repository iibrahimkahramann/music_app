import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:file_picker/file_picker.dart';
import 'package:music_app/playlists/provider/playlist_provider.dart';
import 'package:path_provider/path_provider.dart';

void showAddPlaylistDialog(
    BuildContext context, PlaylistNotifier playlistNotifier) {
  final TextEditingController controller = TextEditingController();
  String? selectedImagePath;

  Future<String?> pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      final File tempFile = File(result.files.single.path!);
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String fileName = result.files.single.name;
      final File savedImage = await tempFile.copy('${appDir.path}/$fileName');
      return savedImage.path;
    }
    return null;
  }

  if (Platform.isIOS) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text('Add to Playlist'),
          content: Column(
            children: <Widget>[
              CupertinoTextField(
                controller: controller,
                placeholder: 'Playlist name',
              ),
              SizedBox(height: 10),
              CupertinoButton(
                onPressed: () async {
                  selectedImagePath = await pickImage();
                },
                child: Text(selectedImagePath == null
                    ? 'Pick Image'
                    : 'Image Selected'),
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
                  playlistNotifier.addPlaylistWithImage(
                      playlistName, selectedImagePath);
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
