import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingService {
  static const _keySeenOnboarding = 'seenOnboarding';

  /// Check if onboarding has been completed
  static Future<bool> hasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keySeenOnboarding) ?? false;
  }

  /// Mark onboarding as completed
  static Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keySeenOnboarding, true);
  }

  /// Reset onboarding (useful for testing/debug)
  static Future<void> resetOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keySeenOnboarding);
  }
}
