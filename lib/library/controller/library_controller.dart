import 'dart:io';
import 'package:adapty_flutter/adapty_flutter.dart';
import 'package:drift/drift.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/db/app_database.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';

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

      if (result == null) {
        print("Kullanıcı dosya seçimini iptal etti.");
        return;
      }

      final originalFile = File(result.files.single.path!);
      final fileName = result.files.single.name;

      // Dosyanın kaydedileceği klasörü al
      final appDir = await getApplicationDocumentsDirectory();
      final musicDir = Directory(path.join(appDir.path, 'music'));

      if (!await musicDir.exists()) {
        await musicDir.create(recursive: true);
      }

      // Aynı isimde dosya olup olmadığını kontrol et
      var newPath = path.join(musicDir.path, fileName);
      int counter = 1;
      while (await File(newPath).exists()) {
        final baseName = path.basenameWithoutExtension(fileName);
        final extension = path.extension(fileName);
        newPath = path.join(musicDir.path, '$baseName ($counter)$extension');
        counter++;
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

      // SharedPreferences'a kaydet
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('lastMusicFilePath', copiedFile.path);

      await printAllMusicFiles();
      print('Müzik dosyası kaydedildi: ${copiedFile.path}');
    } catch (e, stackTrace) {
      print('Hata: $e');
      print('Stack trace: $stackTrace');
    } finally {
      state = false;
    }
  }

  Future<String?> getLastMusicFilePath() async {
    final musicList = await db.getAllMusicFiles();
    if (musicList.isNotEmpty) {
      print('Veritabanından alınan dosya yolu: ${musicList.last.filePath}');
      return musicList.last.filePath;
    } else {
      final prefs = await SharedPreferences.getInstance();
      final filePath = prefs.getString('lastMusicFilePath');
      print('SharedPreferences\'tan alınan dosya yolu: $filePath');
      return filePath;
    }
  }

  Future<String?> getAlternativeMusicFilePath() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('alternativeMusicFilePath');
  }

  Future<void> printAllMusicFiles() async {
    final musicList = await db.getAllMusicFiles();
    if (musicList.isEmpty) {
      print("📂 Veritabanında kayıtlı müzik bulunamadı!");
    } else {
      for (var music in musicList) {
        print(
            "ID: ${music.id}, Dosya: ${music.fileName}, Kapak: ${music.albumArt != null ? '✅ Var' : '❌ Yok'}");
      }
    }
  }
}

Future<void> homePaywall() async {
  try {
    final paywall = await Adapty().getPaywall(
      placementId: 'placement-onboarding',
      locale: 'en',
    );

    final view = await AdaptyUI().createPaywallView(
      paywall: paywall,
    );
    await view.present();
  } on AdaptyError catch (e) {
    print("Adapty hatası: $e");
  } catch (e) {
    print("Beklenmeyen hata: $e");
  }
}
