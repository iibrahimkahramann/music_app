import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:adapty_flutter/adapty_flutter.dart';

class PremiumNotifier extends StateNotifier<bool> {
  PremiumNotifier() : super(false) {
    _initializePremiumStatus();
    Adapty().didUpdateProfileStream.listen((profile) {
      _updateFromProfile(profile);
    });
  }

  Future<void> _initializePremiumStatus() async {
    try {
      final profile = await Adapty().getProfile();
      _updateFromProfile(profile);
    } catch (e) {
      print('Premium durumu başlatılırken hata: $e');
      final prefs = await SharedPreferences.getInstance();
      state = prefs.getBool('isPremium') ?? false;
    }
  }

  void _updateFromProfile(AdaptyProfile profile) {
    final isPremium = profile.accessLevels['premium']?.isActive ?? false;
    updatePremiumStatus(isPremium);
  }

  Future<void> updatePremiumStatus(bool isPremium) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isPremium', isPremium);
    state = isPremium;
    print('Premium durumu güncellendi: $isPremium');
  }
}

final isPremiumProvider = StateNotifierProvider<PremiumNotifier, bool>((ref) {
  return PremiumNotifier();
});
