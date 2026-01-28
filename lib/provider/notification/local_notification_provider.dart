import 'package:flutter/material.dart';
import 'package:restaurant_app/services/local_notification_service.dart';
import 'package:restaurant_app/services/shared_preferences_service.dart';

class LocalNotificationProvider extends ChangeNotifier {
  final LocalNotificationService flutterNotificationService;
  final SharedPreferencesService sharedPreferencesService;

  LocalNotificationProvider(
    this.flutterNotificationService,
    this.sharedPreferencesService,
  ) {
    _loadDailyReminderSetting();
  }

  int _notificationId = 0;
  bool? _permission = false;
  bool? get permission => _permission;

  bool _isDailyReminderActive = false;
  bool get isDailyReminderActive => _isDailyReminderActive;

  void _loadDailyReminderSetting() {
    _isDailyReminderActive = sharedPreferencesService.getDailyReminder();
    notifyListeners();
  }

  Future<void> enableDailyReminder() async {
    _permission = await flutterNotificationService.requestPermissions();
    if (_permission == true) {
      await flutterNotificationService.scheduleDailyElevenAMNotification(id: 1);
      await sharedPreferencesService.saveDailyReminder(true);
      _isDailyReminderActive = true;
      notifyListeners();
    }
  }

  Future<void> disableDailyReminder() async {
    await flutterNotificationService.cancelNotification(1);
    await sharedPreferencesService.saveDailyReminder(false);
    _isDailyReminderActive = false;
    notifyListeners();
  }

  Future<void> requestPermissions() async {
    _permission = await flutterNotificationService.requestPermissions();
    notifyListeners();
  }

  void showNotification() {
    _notificationId += 1;
    flutterNotificationService.showNotification(
      id: _notificationId,
      title: "New Notification",
      body: "This is a new notification with id $_notificationId",
      payload: "This is a payload from notification with id $_notificationId",
    );
  }
}
