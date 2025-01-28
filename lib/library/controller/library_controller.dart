import 'package:drift/drift.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/db/app_database.dart';

// StateNotifier ile dosya seçme durumunu yönetin
class FilePickerNotifier extends StateNotifier<bool> {
  FilePickerNotifier() : super(false);

  final db = AppDatabase();

  Future<void> pickMusicFile() async {
    if (state) return; // Eğer zaten işlem yapılıyorsa, durdur
    state = true; // İşlem başlıyor

    print("Dosya seçme işlemi başladı");

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp3', 'wav', 'm4a'],
      );

      if (result != null) {
        String filePath = result.files.single.path!;
        String fileName = result.files.single.name;

        // Drift veritabanına kaydet
        await db.insertMusicFile(
          MusicFilesCompanion(
            filePath: Value(filePath),
            fileName: Value(fileName),
            createdAt: Value(DateTime.now()),
          ),
        );

        print("Müzik dosyası başarıyla kaydedildi!");
      } else {
        print("Kullanıcı dosya seçimini iptal etti.");
      }
    } catch (e) {
      print("Dosya seçme sırasında bir hata oluştu: $e");
    } finally {
      state = false; // İşlem bitti
      print("Dosya seçme işlemi bitti");
    }
  }
}
