import 'package:flutter/foundation.dart';
import 'package:restaurant_app/services/shared_preferences_service.dart';

class SharedPreferencesProvider extends ChangeNotifier {
  final SharedPreferencesService _service;
  SharedPreferencesProvider(this._service) {
    getThemeValue();
  }

  bool _isDarkTheme = false;
  bool get isDarkTheme => _isDarkTheme;

  String _message = "";

  String get message => _message;

  Future<void> saveThemeValue(bool value) async {
    try {
      await _service.saveTheme(value);
      _isDarkTheme = value;
      _message = "Your data is saved";
    } catch (e) {
      _message = "Failed to save your data";
    }
    notifyListeners();
  }

  Future<void> getThemeValue() async {
    try {
      _isDarkTheme = await _service.getTheme();
      _message = "Data successfully retrieved";
    } catch (e) {
      _message = "Failed to get your data";
    }
    notifyListeners();
  }
}
