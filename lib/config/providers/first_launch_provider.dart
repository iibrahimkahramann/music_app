import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final firstLaunchProvider = FutureProvider<bool>((ref) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isFirstLaunch') ?? true;
});

Future<void> setFirstLaunchDone() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isFirstLaunch', false);
}
