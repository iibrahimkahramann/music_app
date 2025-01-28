// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $MusicFilesTable extends MusicFiles
    with TableInfo<$MusicFilesTable, MusicFile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MusicFilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _filePathMeta =
      const VerificationMeta('filePath');
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
      'file_path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fileNameMeta =
      const VerificationMeta('fileName');
  @override
  late final GeneratedColumn<String> fileName = GeneratedColumn<String>(
      'file_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, filePath, fileName, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'music_files';
  @override
  VerificationContext validateIntegrity(Insertable<MusicFile> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('file_path')) {
      context.handle(_filePathMeta,
          filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta));
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('file_name')) {
      context.handle(_fileNameMeta,
          fileName.isAcceptableOrUnknown(data['file_name']!, _fileNameMeta));
    } else if (isInserting) {
      context.missing(_fileNameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MusicFile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MusicFile(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      filePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}file_path'])!,
      fileName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}file_name'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
    );
  }

  @override
  $MusicFilesTable createAlias(String alias) {
    return $MusicFilesTable(attachedDatabase, alias);
  }
}

class MusicFile extends DataClass implements Insertable<MusicFile> {
  final int id;
  final String filePath;
  final String fileName;
  final DateTime? createdAt;
  const MusicFile(
      {required this.id,
      required this.filePath,
      required this.fileName,
      this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['file_path'] = Variable<String>(filePath);
    map['file_name'] = Variable<String>(fileName);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    return map;
  }

  MusicFilesCompanion toCompanion(bool nullToAbsent) {
    return MusicFilesCompanion(
      id: Value(id),
      filePath: Value(filePath),
      fileName: Value(fileName),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
    );
  }

  factory MusicFile.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MusicFile(
      id: serializer.fromJson<int>(json['id']),
      filePath: serializer.fromJson<String>(json['filePath']),
      fileName: serializer.fromJson<String>(json['fileName']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'filePath': serializer.toJson<String>(filePath),
      'fileName': serializer.toJson<String>(fileName),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
    };
  }

  MusicFile copyWith(
          {int? id,
          String? filePath,
          String? fileName,
          Value<DateTime?> createdAt = const Value.absent()}) =>
      MusicFile(
        id: id ?? this.id,
        filePath: filePath ?? this.filePath,
        fileName: fileName ?? this.fileName,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
      );
  MusicFile copyWithCompanion(MusicFilesCompanion data) {
    return MusicFile(
      id: data.id.present ? data.id.value : this.id,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      fileName: data.fileName.present ? data.fileName.value : this.fileName,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MusicFile(')
          ..write('id: $id, ')
          ..write('filePath: $filePath, ')
          ..write('fileName: $fileName, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, filePath, fileName, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MusicFile &&
          other.id == this.id &&
          other.filePath == this.filePath &&
          other.fileName == this.fileName &&
          other.createdAt == this.createdAt);
}

class MusicFilesCompanion extends UpdateCompanion<MusicFile> {
  final Value<int> id;
  final Value<String> filePath;
  final Value<String> fileName;
  final Value<DateTime?> createdAt;
  const MusicFilesCompanion({
    this.id = const Value.absent(),
    this.filePath = const Value.absent(),
    this.fileName = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  MusicFilesCompanion.insert({
    this.id = const Value.absent(),
    required String filePath,
    required String fileName,
    this.createdAt = const Value.absent(),
  })  : filePath = Value(filePath),
        fileName = Value(fileName);
  static Insertable<MusicFile> custom({
    Expression<int>? id,
    Expression<String>? filePath,
    Expression<String>? fileName,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (filePath != null) 'file_path': filePath,
      if (fileName != null) 'file_name': fileName,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  MusicFilesCompanion copyWith(
      {Value<int>? id,
      Value<String>? filePath,
      Value<String>? fileName,
      Value<DateTime?>? createdAt}) {
    return MusicFilesCompanion(
      id: id ?? this.id,
      filePath: filePath ?? this.filePath,
      fileName: fileName ?? this.fileName,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (fileName.present) {
      map['file_name'] = Variable<String>(fileName.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MusicFilesCompanion(')
          ..write('id: $id, ')
          ..write('filePath: $filePath, ')
          ..write('fileName: $fileName, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $PlaylistFilesTable extends PlaylistFiles
    with TableInfo<$PlaylistFilesTable, PlaylistFile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlaylistFilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _fileNameMeta =
      const VerificationMeta('fileName');
  @override
  late final GeneratedColumn<String> fileName = GeneratedColumn<String>(
      'file_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _imagePathMeta =
      const VerificationMeta('imagePath');
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
      'image_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, fileName, imagePath, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'playlist_files';
  @override
  VerificationContext validateIntegrity(Insertable<PlaylistFile> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('file_name')) {
      context.handle(_fileNameMeta,
          fileName.isAcceptableOrUnknown(data['file_name']!, _fileNameMeta));
    } else if (isInserting) {
      context.missing(_fileNameMeta);
    }
    if (data.containsKey('image_path')) {
      context.handle(_imagePathMeta,
          imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlaylistFile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlaylistFile(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      fileName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}file_name'])!,
      imagePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image_path']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
    );
  }

  @override
  $PlaylistFilesTable createAlias(String alias) {
    return $PlaylistFilesTable(attachedDatabase, alias);
  }
}

class PlaylistFile extends DataClass implements Insertable<PlaylistFile> {
  final int id;
  final String fileName;
  final String? imagePath;
  final DateTime? createdAt;
  const PlaylistFile(
      {required this.id,
      required this.fileName,
      this.imagePath,
      this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['file_name'] = Variable<String>(fileName);
    if (!nullToAbsent || imagePath != null) {
      map['image_path'] = Variable<String>(imagePath);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    return map;
  }

  PlaylistFilesCompanion toCompanion(bool nullToAbsent) {
    return PlaylistFilesCompanion(
      id: Value(id),
      fileName: Value(fileName),
      imagePath: imagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(imagePath),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
    );
  }

  factory PlaylistFile.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlaylistFile(
      id: serializer.fromJson<int>(json['id']),
      fileName: serializer.fromJson<String>(json['fileName']),
      imagePath: serializer.fromJson<String?>(json['imagePath']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'fileName': serializer.toJson<String>(fileName),
      'imagePath': serializer.toJson<String?>(imagePath),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
    };
  }

  PlaylistFile copyWith(
          {int? id,
          String? fileName,
          Value<String?> imagePath = const Value.absent(),
          Value<DateTime?> createdAt = const Value.absent()}) =>
      PlaylistFile(
        id: id ?? this.id,
        fileName: fileName ?? this.fileName,
        imagePath: imagePath.present ? imagePath.value : this.imagePath,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
      );
  PlaylistFile copyWithCompanion(PlaylistFilesCompanion data) {
    return PlaylistFile(
      id: data.id.present ? data.id.value : this.id,
      fileName: data.fileName.present ? data.fileName.value : this.fileName,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlaylistFile(')
          ..write('id: $id, ')
          ..write('fileName: $fileName, ')
          ..write('imagePath: $imagePath, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, fileName, imagePath, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlaylistFile &&
          other.id == this.id &&
          other.fileName == this.fileName &&
          other.imagePath == this.imagePath &&
          other.createdAt == this.createdAt);
}

class PlaylistFilesCompanion extends UpdateCompanion<PlaylistFile> {
  final Value<int> id;
  final Value<String> fileName;
  final Value<String?> imagePath;
  final Value<DateTime?> createdAt;
  const PlaylistFilesCompanion({
    this.id = const Value.absent(),
    this.fileName = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  PlaylistFilesCompanion.insert({
    this.id = const Value.absent(),
    required String fileName,
    this.imagePath = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : fileName = Value(fileName);
  static Insertable<PlaylistFile> custom({
    Expression<int>? id,
    Expression<String>? fileName,
    Expression<String>? imagePath,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fileName != null) 'file_name': fileName,
      if (imagePath != null) 'image_path': imagePath,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  PlaylistFilesCompanion copyWith(
      {Value<int>? id,
      Value<String>? fileName,
      Value<String?>? imagePath,
      Value<DateTime?>? createdAt}) {
    return PlaylistFilesCompanion(
      id: id ?? this.id,
      fileName: fileName ?? this.fileName,
      imagePath: imagePath ?? this.imagePath,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (fileName.present) {
      map['file_name'] = Variable<String>(fileName.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlaylistFilesCompanion(')
          ..write('id: $id, ')
          ..write('fileName: $fileName, ')
          ..write('imagePath: $imagePath, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $PlaylistMusicTable extends PlaylistMusic
    with TableInfo<$PlaylistMusicTable, PlaylistMusicData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlaylistMusicTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _playlistIdMeta =
      const VerificationMeta('playlistId');
  @override
  late final GeneratedColumn<int> playlistId = GeneratedColumn<int>(
      'playlist_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'REFERENCES playlist_files(id) NOT NULL');
  static const VerificationMeta _musicIdMeta =
      const VerificationMeta('musicId');
  @override
  late final GeneratedColumn<int> musicId = GeneratedColumn<int>(
      'music_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'REFERENCES music_files(id) NOT NULL');
  @override
  List<GeneratedColumn> get $columns => [id, playlistId, musicId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'playlist_music';
  @override
  VerificationContext validateIntegrity(Insertable<PlaylistMusicData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('playlist_id')) {
      context.handle(
          _playlistIdMeta,
          playlistId.isAcceptableOrUnknown(
              data['playlist_id']!, _playlistIdMeta));
    } else if (isInserting) {
      context.missing(_playlistIdMeta);
    }
    if (data.containsKey('music_id')) {
      context.handle(_musicIdMeta,
          musicId.isAcceptableOrUnknown(data['music_id']!, _musicIdMeta));
    } else if (isInserting) {
      context.missing(_musicIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlaylistMusicData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlaylistMusicData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      playlistId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}playlist_id'])!,
      musicId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}music_id'])!,
    );
  }

  @override
  $PlaylistMusicTable createAlias(String alias) {
    return $PlaylistMusicTable(attachedDatabase, alias);
  }
}

class PlaylistMusicData extends DataClass
    implements Insertable<PlaylistMusicData> {
  final int id;
  final int playlistId;
  final int musicId;
  const PlaylistMusicData(
      {required this.id, required this.playlistId, required this.musicId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['playlist_id'] = Variable<int>(playlistId);
    map['music_id'] = Variable<int>(musicId);
    return map;
  }

  PlaylistMusicCompanion toCompanion(bool nullToAbsent) {
    return PlaylistMusicCompanion(
      id: Value(id),
      playlistId: Value(playlistId),
      musicId: Value(musicId),
    );
  }

  factory PlaylistMusicData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlaylistMusicData(
      id: serializer.fromJson<int>(json['id']),
      playlistId: serializer.fromJson<int>(json['playlistId']),
      musicId: serializer.fromJson<int>(json['musicId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'playlistId': serializer.toJson<int>(playlistId),
      'musicId': serializer.toJson<int>(musicId),
    };
  }

  PlaylistMusicData copyWith({int? id, int? playlistId, int? musicId}) =>
      PlaylistMusicData(
        id: id ?? this.id,
        playlistId: playlistId ?? this.playlistId,
        musicId: musicId ?? this.musicId,
      );
  PlaylistMusicData copyWithCompanion(PlaylistMusicCompanion data) {
    return PlaylistMusicData(
      id: data.id.present ? data.id.value : this.id,
      playlistId:
          data.playlistId.present ? data.playlistId.value : this.playlistId,
      musicId: data.musicId.present ? data.musicId.value : this.musicId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlaylistMusicData(')
          ..write('id: $id, ')
          ..write('playlistId: $playlistId, ')
          ..write('musicId: $musicId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, playlistId, musicId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlaylistMusicData &&
          other.id == this.id &&
          other.playlistId == this.playlistId &&
          other.musicId == this.musicId);
}

class PlaylistMusicCompanion extends UpdateCompanion<PlaylistMusicData> {
  final Value<int> id;
  final Value<int> playlistId;
  final Value<int> musicId;
  const PlaylistMusicCompanion({
    this.id = const Value.absent(),
    this.playlistId = const Value.absent(),
    this.musicId = const Value.absent(),
  });
  PlaylistMusicCompanion.insert({
    this.id = const Value.absent(),
    required int playlistId,
    required int musicId,
  })  : playlistId = Value(playlistId),
        musicId = Value(musicId);
  static Insertable<PlaylistMusicData> custom({
    Expression<int>? id,
    Expression<int>? playlistId,
    Expression<int>? musicId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (playlistId != null) 'playlist_id': playlistId,
      if (musicId != null) 'music_id': musicId,
    });
  }

  PlaylistMusicCompanion copyWith(
      {Value<int>? id, Value<int>? playlistId, Value<int>? musicId}) {
    return PlaylistMusicCompanion(
      id: id ?? this.id,
      playlistId: playlistId ?? this.playlistId,
      musicId: musicId ?? this.musicId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (playlistId.present) {
      map['playlist_id'] = Variable<int>(playlistId.value);
    }
    if (musicId.present) {
      map['music_id'] = Variable<int>(musicId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlaylistMusicCompanion(')
          ..write('id: $id, ')
          ..write('playlistId: $playlistId, ')
          ..write('musicId: $musicId')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $MusicFilesTable musicFiles = $MusicFilesTable(this);
  late final $PlaylistFilesTable playlistFiles = $PlaylistFilesTable(this);
  late final $PlaylistMusicTable playlistMusic = $PlaylistMusicTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [musicFiles, playlistFiles, playlistMusic];
}

typedef $$MusicFilesTableCreateCompanionBuilder = MusicFilesCompanion Function({
  Value<int> id,
  required String filePath,
  required String fileName,
  Value<DateTime?> createdAt,
});
typedef $$MusicFilesTableUpdateCompanionBuilder = MusicFilesCompanion Function({
  Value<int> id,
  Value<String> filePath,
  Value<String> fileName,
  Value<DateTime?> createdAt,
});

final class $$MusicFilesTableReferences
    extends BaseReferences<_$AppDatabase, $MusicFilesTable, MusicFile> {
  $$MusicFilesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PlaylistMusicTable, List<PlaylistMusicData>>
      _playlistMusicRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.playlistMusic,
              aliasName: $_aliasNameGenerator(
                  db.musicFiles.id, db.playlistMusic.musicId));

  $$PlaylistMusicTableProcessedTableManager get playlistMusicRefs {
    final manager = $$PlaylistMusicTableTableManager($_db, $_db.playlistMusic)
        .filter((f) => f.musicId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_playlistMusicRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$MusicFilesTableFilterComposer
    extends Composer<_$AppDatabase, $MusicFilesTable> {
  $$MusicFilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get filePath => $composableBuilder(
      column: $table.filePath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fileName => $composableBuilder(
      column: $table.fileName, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  Expression<bool> playlistMusicRefs(
      Expression<bool> Function($$PlaylistMusicTableFilterComposer f) f) {
    final $$PlaylistMusicTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.playlistMusic,
        getReferencedColumn: (t) => t.musicId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlaylistMusicTableFilterComposer(
              $db: $db,
              $table: $db.playlistMusic,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$MusicFilesTableOrderingComposer
    extends Composer<_$AppDatabase, $MusicFilesTable> {
  $$MusicFilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get filePath => $composableBuilder(
      column: $table.filePath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fileName => $composableBuilder(
      column: $table.fileName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$MusicFilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MusicFilesTable> {
  $$MusicFilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<String> get fileName =>
      $composableBuilder(column: $table.fileName, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> playlistMusicRefs<T extends Object>(
      Expression<T> Function($$PlaylistMusicTableAnnotationComposer a) f) {
    final $$PlaylistMusicTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.playlistMusic,
        getReferencedColumn: (t) => t.musicId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlaylistMusicTableAnnotationComposer(
              $db: $db,
              $table: $db.playlistMusic,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$MusicFilesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MusicFilesTable,
    MusicFile,
    $$MusicFilesTableFilterComposer,
    $$MusicFilesTableOrderingComposer,
    $$MusicFilesTableAnnotationComposer,
    $$MusicFilesTableCreateCompanionBuilder,
    $$MusicFilesTableUpdateCompanionBuilder,
    (MusicFile, $$MusicFilesTableReferences),
    MusicFile,
    PrefetchHooks Function({bool playlistMusicRefs})> {
  $$MusicFilesTableTableManager(_$AppDatabase db, $MusicFilesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MusicFilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MusicFilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MusicFilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> filePath = const Value.absent(),
            Value<String> fileName = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
          }) =>
              MusicFilesCompanion(
            id: id,
            filePath: filePath,
            fileName: fileName,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String filePath,
            required String fileName,
            Value<DateTime?> createdAt = const Value.absent(),
          }) =>
              MusicFilesCompanion.insert(
            id: id,
            filePath: filePath,
            fileName: fileName,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$MusicFilesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({playlistMusicRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (playlistMusicRefs) db.playlistMusic
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (playlistMusicRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$MusicFilesTableReferences
                            ._playlistMusicRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MusicFilesTableReferences(db, table, p0)
                                .playlistMusicRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.musicId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$MusicFilesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MusicFilesTable,
    MusicFile,
    $$MusicFilesTableFilterComposer,
    $$MusicFilesTableOrderingComposer,
    $$MusicFilesTableAnnotationComposer,
    $$MusicFilesTableCreateCompanionBuilder,
    $$MusicFilesTableUpdateCompanionBuilder,
    (MusicFile, $$MusicFilesTableReferences),
    MusicFile,
    PrefetchHooks Function({bool playlistMusicRefs})>;
typedef $$PlaylistFilesTableCreateCompanionBuilder = PlaylistFilesCompanion
    Function({
  Value<int> id,
  required String fileName,
  Value<String?> imagePath,
  Value<DateTime?> createdAt,
});
typedef $$PlaylistFilesTableUpdateCompanionBuilder = PlaylistFilesCompanion
    Function({
  Value<int> id,
  Value<String> fileName,
  Value<String?> imagePath,
  Value<DateTime?> createdAt,
});

final class $$PlaylistFilesTableReferences
    extends BaseReferences<_$AppDatabase, $PlaylistFilesTable, PlaylistFile> {
  $$PlaylistFilesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PlaylistMusicTable, List<PlaylistMusicData>>
      _playlistMusicRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.playlistMusic,
              aliasName: $_aliasNameGenerator(
                  db.playlistFiles.id, db.playlistMusic.playlistId));

  $$PlaylistMusicTableProcessedTableManager get playlistMusicRefs {
    final manager = $$PlaylistMusicTableTableManager($_db, $_db.playlistMusic)
        .filter((f) => f.playlistId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_playlistMusicRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$PlaylistFilesTableFilterComposer
    extends Composer<_$AppDatabase, $PlaylistFilesTable> {
  $$PlaylistFilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fileName => $composableBuilder(
      column: $table.fileName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get imagePath => $composableBuilder(
      column: $table.imagePath, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  Expression<bool> playlistMusicRefs(
      Expression<bool> Function($$PlaylistMusicTableFilterComposer f) f) {
    final $$PlaylistMusicTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.playlistMusic,
        getReferencedColumn: (t) => t.playlistId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlaylistMusicTableFilterComposer(
              $db: $db,
              $table: $db.playlistMusic,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$PlaylistFilesTableOrderingComposer
    extends Composer<_$AppDatabase, $PlaylistFilesTable> {
  $$PlaylistFilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fileName => $composableBuilder(
      column: $table.fileName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get imagePath => $composableBuilder(
      column: $table.imagePath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$PlaylistFilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlaylistFilesTable> {
  $$PlaylistFilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get fileName =>
      $composableBuilder(column: $table.fileName, builder: (column) => column);

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> playlistMusicRefs<T extends Object>(
      Expression<T> Function($$PlaylistMusicTableAnnotationComposer a) f) {
    final $$PlaylistMusicTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.playlistMusic,
        getReferencedColumn: (t) => t.playlistId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlaylistMusicTableAnnotationComposer(
              $db: $db,
              $table: $db.playlistMusic,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$PlaylistFilesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PlaylistFilesTable,
    PlaylistFile,
    $$PlaylistFilesTableFilterComposer,
    $$PlaylistFilesTableOrderingComposer,
    $$PlaylistFilesTableAnnotationComposer,
    $$PlaylistFilesTableCreateCompanionBuilder,
    $$PlaylistFilesTableUpdateCompanionBuilder,
    (PlaylistFile, $$PlaylistFilesTableReferences),
    PlaylistFile,
    PrefetchHooks Function({bool playlistMusicRefs})> {
  $$PlaylistFilesTableTableManager(_$AppDatabase db, $PlaylistFilesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlaylistFilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlaylistFilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlaylistFilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> fileName = const Value.absent(),
            Value<String?> imagePath = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
          }) =>
              PlaylistFilesCompanion(
            id: id,
            fileName: fileName,
            imagePath: imagePath,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String fileName,
            Value<String?> imagePath = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
          }) =>
              PlaylistFilesCompanion.insert(
            id: id,
            fileName: fileName,
            imagePath: imagePath,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$PlaylistFilesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({playlistMusicRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (playlistMusicRefs) db.playlistMusic
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (playlistMusicRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$PlaylistFilesTableReferences
                            ._playlistMusicRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PlaylistFilesTableReferences(db, table, p0)
                                .playlistMusicRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.playlistId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$PlaylistFilesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PlaylistFilesTable,
    PlaylistFile,
    $$PlaylistFilesTableFilterComposer,
    $$PlaylistFilesTableOrderingComposer,
    $$PlaylistFilesTableAnnotationComposer,
    $$PlaylistFilesTableCreateCompanionBuilder,
    $$PlaylistFilesTableUpdateCompanionBuilder,
    (PlaylistFile, $$PlaylistFilesTableReferences),
    PlaylistFile,
    PrefetchHooks Function({bool playlistMusicRefs})>;
typedef $$PlaylistMusicTableCreateCompanionBuilder = PlaylistMusicCompanion
    Function({
  Value<int> id,
  required int playlistId,
  required int musicId,
});
typedef $$PlaylistMusicTableUpdateCompanionBuilder = PlaylistMusicCompanion
    Function({
  Value<int> id,
  Value<int> playlistId,
  Value<int> musicId,
});

final class $$PlaylistMusicTableReferences extends BaseReferences<_$AppDatabase,
    $PlaylistMusicTable, PlaylistMusicData> {
  $$PlaylistMusicTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $PlaylistFilesTable _playlistIdTable(_$AppDatabase db) =>
      db.playlistFiles.createAlias($_aliasNameGenerator(
          db.playlistMusic.playlistId, db.playlistFiles.id));

  $$PlaylistFilesTableProcessedTableManager get playlistId {
    final $_column = $_itemColumn<int>('playlist_id')!;

    final manager = $$PlaylistFilesTableTableManager($_db, $_db.playlistFiles)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_playlistIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $MusicFilesTable _musicIdTable(_$AppDatabase db) =>
      db.musicFiles.createAlias(
          $_aliasNameGenerator(db.playlistMusic.musicId, db.musicFiles.id));

  $$MusicFilesTableProcessedTableManager get musicId {
    final $_column = $_itemColumn<int>('music_id')!;

    final manager = $$MusicFilesTableTableManager($_db, $_db.musicFiles)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_musicIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$PlaylistMusicTableFilterComposer
    extends Composer<_$AppDatabase, $PlaylistMusicTable> {
  $$PlaylistMusicTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  $$PlaylistFilesTableFilterComposer get playlistId {
    final $$PlaylistFilesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.playlistId,
        referencedTable: $db.playlistFiles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlaylistFilesTableFilterComposer(
              $db: $db,
              $table: $db.playlistFiles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$MusicFilesTableFilterComposer get musicId {
    final $$MusicFilesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.musicId,
        referencedTable: $db.musicFiles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MusicFilesTableFilterComposer(
              $db: $db,
              $table: $db.musicFiles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PlaylistMusicTableOrderingComposer
    extends Composer<_$AppDatabase, $PlaylistMusicTable> {
  $$PlaylistMusicTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  $$PlaylistFilesTableOrderingComposer get playlistId {
    final $$PlaylistFilesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.playlistId,
        referencedTable: $db.playlistFiles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlaylistFilesTableOrderingComposer(
              $db: $db,
              $table: $db.playlistFiles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$MusicFilesTableOrderingComposer get musicId {
    final $$MusicFilesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.musicId,
        referencedTable: $db.musicFiles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MusicFilesTableOrderingComposer(
              $db: $db,
              $table: $db.musicFiles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PlaylistMusicTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlaylistMusicTable> {
  $$PlaylistMusicTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  $$PlaylistFilesTableAnnotationComposer get playlistId {
    final $$PlaylistFilesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.playlistId,
        referencedTable: $db.playlistFiles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlaylistFilesTableAnnotationComposer(
              $db: $db,
              $table: $db.playlistFiles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$MusicFilesTableAnnotationComposer get musicId {
    final $$MusicFilesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.musicId,
        referencedTable: $db.musicFiles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MusicFilesTableAnnotationComposer(
              $db: $db,
              $table: $db.musicFiles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PlaylistMusicTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PlaylistMusicTable,
    PlaylistMusicData,
    $$PlaylistMusicTableFilterComposer,
    $$PlaylistMusicTableOrderingComposer,
    $$PlaylistMusicTableAnnotationComposer,
    $$PlaylistMusicTableCreateCompanionBuilder,
    $$PlaylistMusicTableUpdateCompanionBuilder,
    (PlaylistMusicData, $$PlaylistMusicTableReferences),
    PlaylistMusicData,
    PrefetchHooks Function({bool playlistId, bool musicId})> {
  $$PlaylistMusicTableTableManager(_$AppDatabase db, $PlaylistMusicTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlaylistMusicTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlaylistMusicTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlaylistMusicTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> playlistId = const Value.absent(),
            Value<int> musicId = const Value.absent(),
          }) =>
              PlaylistMusicCompanion(
            id: id,
            playlistId: playlistId,
            musicId: musicId,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int playlistId,
            required int musicId,
          }) =>
              PlaylistMusicCompanion.insert(
            id: id,
            playlistId: playlistId,
            musicId: musicId,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$PlaylistMusicTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({playlistId = false, musicId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (playlistId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.playlistId,
                    referencedTable:
                        $$PlaylistMusicTableReferences._playlistIdTable(db),
                    referencedColumn:
                        $$PlaylistMusicTableReferences._playlistIdTable(db).id,
                  ) as T;
                }
                if (musicId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.musicId,
                    referencedTable:
                        $$PlaylistMusicTableReferences._musicIdTable(db),
                    referencedColumn:
                        $$PlaylistMusicTableReferences._musicIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$PlaylistMusicTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PlaylistMusicTable,
    PlaylistMusicData,
    $$PlaylistMusicTableFilterComposer,
    $$PlaylistMusicTableOrderingComposer,
    $$PlaylistMusicTableAnnotationComposer,
    $$PlaylistMusicTableCreateCompanionBuilder,
    $$PlaylistMusicTableUpdateCompanionBuilder,
    (PlaylistMusicData, $$PlaylistMusicTableReferences),
    PlaylistMusicData,
    PrefetchHooks Function({bool playlistId, bool musicId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$MusicFilesTableTableManager get musicFiles =>
      $$MusicFilesTableTableManager(_db, _db.musicFiles);
  $$PlaylistFilesTableTableManager get playlistFiles =>
      $$PlaylistFilesTableTableManager(_db, _db.playlistFiles);
  $$PlaylistMusicTableTableManager get playlistMusic =>
      $$PlaylistMusicTableTableManager(_db, _db.playlistMusic);
}
