import 'dart:math';
import 'package:restaurant_app/services/api_services.dart';
import 'package:restaurant_app/services/local_notification_service.dart';
import 'package:restaurant_app/static/my_workmanager.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == MyWorkmanager.periodic.taskName ||
        task == MyWorkmanager.periodic.uniqueName) {
      final httpService = ApiServices();
      final result = await httpService.getRestaurantList();

      if (result.restaurants.isNotEmpty) {
        final restaurants = result.restaurants;
        final randomNumber = Random().nextInt(restaurants.length);
        final restaurant = restaurants[randomNumber];

        final LocalNotificationService notificationService =
            LocalNotificationService();

        await notificationService.showNotification(
          id: 1,
          title: "Rekomendasi Makan Siang",
          body:
              "${restaurant.name} di ${restaurant.city} ⭐ ${restaurant.rating}",
          payload: restaurant.id,
          channelId: "daily_reminder",
          channelName: "Daily Reminder",
        );
      }
    }
    return Future.value(true);
  });
}

class WorkManagerService {
  final Workmanager _workmanager;

  WorkManagerService([Workmanager? workmanager])
    : _workmanager = workmanager ??= Workmanager();

  Future<void> init() async {
    await _workmanager.initialize(callbackDispatcher);
  }

  Future<void> runPeriodicTask() async {
    await _workmanager.registerPeriodicTask(
      MyWorkmanager.periodic.uniqueName,
      MyWorkmanager.periodic.taskName,
      constraints: Constraints(networkType: NetworkType.connected),
      initialDelay: const Duration(seconds: 5),
      inputData: {
        "data": "This is a valid payload from periodic task workmanager",
      },
    );
  }

  Future<void> cancelAllTask() async {
    await _workmanager.cancelAll();
  }
}
