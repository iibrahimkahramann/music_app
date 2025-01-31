import 'dart:io';
import 'package:drift/drift.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/db/app_database.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

// StateNotifier ile dosya seçme durumunu yönetin
class FilePickerNotifier extends StateNotifier<bool> {
  FilePickerNotifier() : super(false);

  final db = AppDatabase();

  Future<void> pickMusicFile() async {
    if (state) return;
    state = true;

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp3', 'wav', 'm4a'],
      );

      if (result != null) {
        final originalFile = File(result.files.single.path!);
        final fileName = result.files.single.name;

        // Dosyayı kalıcı bir konuma kopyalayalım
        final appDir = await getApplicationDocumentsDirectory();
        final musicDir = Directory(path.join(appDir.path, 'music'));

        // Müzik dizinini oluştur
        if (!await musicDir.exists()) {
          await musicDir.create(recursive: true);
        }

        // Hedef dosya yolunu oluştur
        final newPath = path.join(musicDir.path, fileName);

        // Eğer aynı isimde dosya varsa, üzerine yazma
        if (await File(newPath).exists()) {
          final baseName = path.basenameWithoutExtension(fileName);
          final extension = path.extension(fileName);
          var counter = 1;
          var newFileName = fileName;

          while (await File(path.join(musicDir.path, newFileName)).exists()) {
            newFileName = '$baseName ($counter)$extension';
            counter++;
          }

          final newPath = path.join(musicDir.path, newFileName);
        }

        // Dosyayı kopyala
        final copiedFile = await originalFile.copy(newPath);
        print('Dosya kopyalandı: ${copiedFile.path}');

        // Veritabanına kaydet
        await db.insertMusicFile(
          MusicFilesCompanion(
            filePath: Value(copiedFile.path),
            fileName: Value(path.basename(copiedFile.path)),
            createdAt: Value(DateTime.now()),
          ),
        );

        print('Müzik dosyası kalıcı konuma kaydedildi: ${copiedFile.path}');
      } else {
        print("Kullanıcı dosya seçimini iptal etti.");
      }
    } catch (e, stackTrace) {
      print('Hata: $e');
      print('Stack trace: $stackTrace');
    } finally {
      state = false;
    }
  }
}
