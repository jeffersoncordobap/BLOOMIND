import 'package:shared_preferences/shared_preferences.dart';
import 'package:bloomind/core/utils/app_preferences.dart';

class OnboardingLocalService {
  Future<bool> hasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(AppPreferences.seenOnboarding) ?? false;
  }

  Future<void> setSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppPreferences.seenOnboarding, true);
  }
}