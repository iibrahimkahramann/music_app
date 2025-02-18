import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/db/app_database.dart';

final selectedMusicProvider = StateProvider<MusicFile?>((ref) => null);
