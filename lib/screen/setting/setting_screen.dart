import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/theme/shared_preferences_provider.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Consumer<SharedPreferencesProvider>(
                builder: (context, tes, child) => ListTile(
                  title: Text('Dark Theme'),
                  trailing: Switch(
                    value: tes.isDarkTheme,
                    onChanged: (value) => context
                        .read<SharedPreferencesProvider>()
                        .saveThemeValue(value),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
