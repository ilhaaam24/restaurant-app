import 'package:flutter/material.dart';
import 'package:restaurant_app/model/restaurant_model.dart';
import 'package:restaurant_app/services/sqlite_service.dart';

class LocalDatabaseProvider extends ChangeNotifier {
  final SqliteService _sqliteService;

  LocalDatabaseProvider(this._sqliteService);

  String _message = "";
  String get message => _message;

  List<Restaurant>? _restaurantList;
  List<Restaurant>? get restaurantList => _restaurantList;

  Restaurant? _restaurant;
  Restaurant? get restaurant => _restaurant;

  set message(String value) {
    _message = value;
    notifyListeners();
  }

  Future<void> saveRestaurantValue(Restaurant value) async {
    try {
      final result = await _sqliteService.insertItem(value);

      final isError = result == 0;
      if (isError) {
        _message = "Failed to save your data";
        notifyListeners();
      } else {
        _message = "Your data is saved";
        notifyListeners();
      }
    } catch (e) {
      _message = "Failed to save your data";
      notifyListeners();
    }
  }

  Future<void> getAllRestaurantValue() async {
    try {
      final result = await _sqliteService.getAllItems();
      _restaurantList = result;
      notifyListeners();
    } catch (e) {
      _message = "Failed to get your data";
      notifyListeners();
    }
  }

  Future<void> getRestaurantValueById(String id) async {
    try {
      final result = await _sqliteService.getItemById(id);
      _restaurant = result;
      notifyListeners();
    } catch (e) {
      _message = "Failed to get your data";
      notifyListeners();
    }
  }

  Future<void> deleteValue(String id) async {
    try {
      final result = await _sqliteService.deleteItem(id);

      final isError = result == 0;
      if (isError) {
        _message = "Failed to delete your data";
        notifyListeners();
      } else {
        _message = "Your data is deleted";
        notifyListeners();
      }
    } catch (e) {
      _message = "Failed to delete your data";
      notifyListeners();
    }
  }

  Future<bool> checkFavoriteStatus(String id) async {
    try {
      final result = await _sqliteService.getItemById(id);
      notifyListeners();
      return result != null;
    } catch (e) {
      _message = "Failed to check favorite status";
      notifyListeners();
      return false;
    }
  }
}
