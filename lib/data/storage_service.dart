import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _unlockedLevelKey = 'unlocked_level';
  static const String _starsKey = 'level_stars_';
  static const String _soundEnabledKey = 'sound_enabled';

  static StorageService? _instance;
  late SharedPreferences _prefs;

  StorageService._();

  static Future<StorageService> getInstance() async {
    if (_instance == null) {
      _instance = StorageService._();
      _instance!._prefs = await SharedPreferences.getInstance();
    }
    return _instance!;
  }

  int get unlockedLevel => _prefs.getInt(_unlockedLevelKey) ?? 0;

  Future<void> setUnlockedLevel(int level) async {
    final current = unlockedLevel;
    if (level > current) {
      await _prefs.setInt(_unlockedLevelKey, level);
    }
  }

  int getStars(int levelIndex) {
    return _prefs.getInt('$_starsKey$levelIndex') ?? 0;
  }

  Future<void> setStars(int levelIndex, int stars) async {
    final current = getStars(levelIndex);
    if (stars > current) {
      await _prefs.setInt('$_starsKey$levelIndex', stars);
    }
  }

  bool get soundEnabled => _prefs.getBool(_soundEnabledKey) ?? true;

  Future<void> setSoundEnabled(bool enabled) async {
    await _prefs.setBool(_soundEnabledKey, enabled);
  }

  Future<void> completeLevel(int levelIndex, int stars) async {
    await setStars(levelIndex, stars);
    await setUnlockedLevel(levelIndex + 1);
  }

  bool isLevelUnlocked(int levelIndex) {
    return levelIndex <= unlockedLevel;
  }

  int calculateStars(int pairs, int flipCount) {
    final perfectFlips = pairs * 2;
    final goodFlips = pairs * 3;

    if (flipCount <= perfectFlips) return 3;
    if (flipCount <= goodFlips) return 2;
    return 1;
  }

  Future<void> resetProgress() async {
    await _prefs.setInt(_unlockedLevelKey, 0);
    for (int i = 0; i < 100; i++) {
      await _prefs.remove('$_starsKey$i');
    }
  }
}
