import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/notification/local_notification_provider.dart';
import 'package:restaurant_app/provider/theme/shared_preferences_provider.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  Future<void> _requestPermission() async {
    context.read<LocalNotificationProvider>().requestPermissions();
  }

  Future<void> _showNotification() async {
    context.read<LocalNotificationProvider>().showNotification();
  }

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
                trailing: Switch(
                  value: provider.permission ?? false,

                  onChanged: (value) async {
                    if (provider.permission ?? false) {
                      await _showNotification();
                    } else {
                      await _requestPermission();
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
