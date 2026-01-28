import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  final SharedPreferences _preferences;
  SharedPreferencesService(this._preferences);

  static const String _keyTheme = "IS_DARK_THEME";

  Future<void> saveTheme(bool value) async {
    try {
      await _preferences.setBool(_keyTheme, value);
    } catch (e) {
      throw ("Shared preferences cannot save the setting value.");
    }
  }

  Future<bool> getTheme() async {
    try {
      return _preferences.getBool(_keyTheme) ?? false;
    } catch (e) {
      throw ("Shared preferences cannot get the setting value.");
    }
  }

  static const String _keyDailyReminder = "IS_DAILY_REMINDER_ACTIVE";

  Future<void> saveDailyReminder(bool value) async {
    try {
      await _preferences.setBool(_keyDailyReminder, value);
    } catch (e) {
      throw ("Shared preferences cannot save the daily reminder value.");
    }
  }

  bool getDailyReminder() {
    return _preferences.getBool(_keyDailyReminder) ?? false;
  }
}
