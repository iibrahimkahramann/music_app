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

// Playlist Tablosu
class PlaylistFiles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get fileName => text()();
  TextColumn get imagePath => text().nullable()();
  DateTimeColumn get createdAt => dateTime().nullable()();
}

// playliste eklenen müzikleri tutan tablo
class PlaylistMusic extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get playlistId =>
      integer().customConstraint('REFERENCES playlist_files(id) NOT NULL')();
  IntColumn get musicId =>
      integer().customConstraint('REFERENCES music_files(id) NOT NULL')();
}

// Drift Veritabanı sınıfı
@DriftDatabase(tables: [MusicFiles, PlaylistFiles, PlaylistMusic])
class AppDatabase extends _$AppDatabase {
  // Singleton örneği, birden fazla veeritabanı
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

  // Tüm playlist dosyalarını al
  Future<List<PlaylistFile>> getAllPlaylistFiles() =>
      select(playlistFiles).get();

  // Yeni bir çalma listesi oluştur
  Future<int> insertPlaylist(PlaylistFilesCompanion playlist) =>
      into(playlistFiles).insert(playlist);

  // Çalma listesine müzik ekle
  Future<void> addMusicToPlaylist(int playlistId, int musicId) async {
    await into(playlistMusic).insert(
      PlaylistMusicCompanion(
        playlistId: Value(playlistId),
        musicId: Value(musicId),
      ),
    );
  }

  // Çalma listesinde müzikleri al
  Future<List<MusicFile>> getMusicInPlaylist(int playlistId) async {
    final query = select(musicFiles).join([
      innerJoin(playlistMusic, playlistMusic.musicId.equalsExp(musicFiles.id))
    ])
      ..where(playlistMusic.playlistId.equals(playlistId));

    final result = await query.get();
    return result.map((row) => row.readTable(musicFiles)).toList();
  }

  // Playlist'i sil
  Future<int> deletePlaylist(int id) async {
    // Önce playlist'e ait müzikleri sil
    await (delete(playlistMusic)..where((tbl) => tbl.playlistId.equals(id)))
        .go();
    // Sonra playlist'i sil
    return (delete(playlistFiles)..where((tbl) => tbl.id.equals(id))).go();
  }

  // Playlist'ten müzik sil
  Future<int> deleteMusicFromPlaylist(int playlistId, int musicId) async {
    return (delete(playlistMusic)
          ..where((tbl) =>
              tbl.playlistId.equals(playlistId) & tbl.musicId.equals(musicId)))
        .go();
  }
}

// Veritabanı bağlantısını açan fonksiyon
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'music_app.sqlite'));
    return NativeDatabase(file,
        logStatements: true); // SQL loglarını etkinleştir
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
