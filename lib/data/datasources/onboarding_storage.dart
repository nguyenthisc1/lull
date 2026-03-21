import 'package:shared_preferences/shared_preferences.dart';

abstract final class OnboardingStorage {
  static const _kKey = 'has_seen_splash';

  static Future<bool> hasSeenSplash() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kKey) ?? false;
  }

  static Future<void> markSplashSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kKey, true);
  }
}
