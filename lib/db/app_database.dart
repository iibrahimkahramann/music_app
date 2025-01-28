import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

// Music Tablosu
class MusicFiles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get filePath => text()();
  TextColumn get fileName => text()();
  DateTimeColumn get createdAt => dateTime().nullable()();
}

// Drift Veritabanı sınıfı
@DriftDatabase(tables: [MusicFiles])
class AppDatabase extends _$AppDatabase {
  // Singleton örneği, birden fazla veeritabanı oluşturmasını önlüyor
  static final AppDatabase _instance = AppDatabase._internal();

  factory AppDatabase() {
    return _instance;
  }

  AppDatabase._internal() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // Tüm müzik dosyalarını al
  Future<List<MusicFile>> getAllMusicFiles() => select(musicFiles).get();

  // Yeni bir müzik dosyası ekle
  Future<int> insertMusicFile(MusicFilesCompanion file) =>
      into(musicFiles).insert(file);

  // Belirli bir dosyayı sil
  Future<int> deleteMusicFile(int id) =>
      (delete(musicFiles)..where((tbl) => tbl.id.equals(id))).go();
}

// Veritabanı bağlantısını açan fonksiyon
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'music_app.sqlite'));
    return NativeDatabase(file);
  });
}

Future<void> addMusicFile(String filePath, String fileName) async {
  final db = AppDatabase();

  await db.insertMusicFile(
    MusicFilesCompanion(
      filePath: Value(filePath),
      fileName: Value(fileName),
    ),
  );

  print('Müzik dosyası başarıyla eklendi!');
}
