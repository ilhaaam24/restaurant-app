import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/notification/local_notification_provider.dart';
import 'package:restaurant_app/provider/theme/shared_preferences_provider.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            child: Consumer<SharedPreferencesProvider>(
              builder: (context, provider, child) => ListTile(
                title: Text('Dark Theme'),
                trailing: Switch(
                  value: provider.isDarkTheme,
                  onChanged: (value) => context
                      .read<SharedPreferencesProvider>()
                      .saveThemeValue(value),
                ),
              ),
            ),
          ),
          SizedBox(
            child: Consumer<LocalNotificationProvider>(
              builder: (context, provider, child) => ListTile(
                title: Text('Daily Notification at 11:00 AM'),
                subtitle: Text('Reminder for lunch'),
                trailing: Switch(
                  value: provider.isDailyReminderActive,
                  onChanged: (value) async {
                    if (value) {
                      await provider.enableDailyReminder();
                    } else {
                      await provider.disableDailyReminder();
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
