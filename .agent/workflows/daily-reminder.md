---
description: Implementasi Fitur Daily Reminder dengan WorkManager dan Notifikasi Random Restaurant
---

# Workflow: Daily Reminder & Random Restaurant Notification

Workflow ini mencakup dua task utama:
- **Task 1**: Fitur pengaturan Daily Reminder di halaman Setting
- **Task 2**: Modifikasi notifikasi untuk menampilkan restoran acak dari API menggunakan WorkManager

---

## 📊 Analisis Kode Existing

### ✅ Yang Sudah Ada

| File | Status | Keterangan |
|------|--------|------------|
| `services/local_notification_service.dart` | ✅ Lengkap | Sudah ada `scheduleDailyElevenAMNotification()`, `showNotification()`, dan `cancelNotification()` |
| `services/shared_preferences_service.dart` | ✅ Lengkap | Sudah ada `saveDailyReminder()` dan `getDailyReminder()` |
| `services/work_manager_service.dart` | ⚠️ Perlu Modifikasi | Masih fetch ke jsonplaceholder, harus diubah ke Restaurant API |
| `provider/notification/local_notification_provider.dart` | ⚠️ Perlu Modifikasi | Perlu integrasi dengan WorkManager |
| `screen/setting/setting_screen.dart` | ⚠️ Perlu Modifikasi | Sudah ada switch, tapi logic perlu diperbaiki |
| `AndroidManifest.xml` | ✅ Lengkap | Permission sudah dikonfigurasi |

### ❌ Yang Perlu Dibuat/Dimodifikasi

1. **WorkManager** harus fetch data dari Restaurant API (`https://restaurant-api.dicoding.dev/list`)
2. **Notifikasi** harus menampilkan info restoran acak (nama, kota, rating)
3. **Setting Screen** perlu memperbaiki logic toggle (hapus unused code)

---

## 🔧 TASK 1: Fitur Pengaturan Daily Reminder

### Step 1.1: Review dan Perbaiki `setting_screen.dart`

**File**: `lib/screen/setting/setting_screen.dart`

**Yang perlu diubah**:
- Hapus fungsi `_runBackgroundOneOffTask()` yang tidak relevan saat disable reminder
- Pastikan toggle bekerja dengan benar untuk enable/disable daily reminder

```dart
// Perbaikan pada onChanged callback
onChanged: (value) async {
  if (value) {
    await provider.enableDailyReminder();
  } else {
    await provider.disableDailyReminder();
  }
},
```

### Step 1.2: Verifikasi Shared Preferences

**File**: `lib/services/shared_preferences_service.dart`

✅ Sudah lengkap dengan:
- `saveDailyReminder(bool value)` - menyimpan status reminder
- `getDailyReminder()` - mengambil status reminder

### Step 1.3: Verifikasi Local Notification Provider

**File**: `lib/provider/notification/local_notification_provider.dart`

✅ Sudah lengkap dengan:
- `enableDailyReminder()` - schedule notification + save to prefs
- `disableDailyReminder()` - cancel notification + save to prefs
- `_loadDailyReminderSetting()` - load status dari prefs saat init

---

## 🔧 TASK 2: Modifikasi Daily Reminder dengan Random Restaurant

### Step 2.1: Modifikasi `work_manager_service.dart`

**File**: `lib/services/work_manager_service.dart`

**Perubahan yang diperlukan**:

1. Ubah URL dari jsonplaceholder ke Restaurant API
2. Parse response JSON untuk mendapatkan list restaurant
3. Pilih restaurant secara random
4. Tampilkan notifikasi dengan info restaurant

```dart
import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:restaurant_app/services/local_notification_service.dart';
import 'package:restaurant_app/static/my_workmanager.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == MyWorkmanager.periodic.taskName ||
        task == MyWorkmanager.periodic.uniqueName) {
      try {
        // Fetch restaurant list dari API
        final response = await http.get(
          Uri.parse("https://restaurant-api.dicoding.dev/list"),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final List restaurants = data['restaurants'];

          if (restaurants.isNotEmpty) {
            // Pilih restaurant secara random
            final randomIndex = Random().nextInt(restaurants.length);
            final restaurant = restaurants[randomIndex];

            // Tampilkan notifikasi
            final notificationService = LocalNotificationService();
            await notificationService.init();
            await notificationService.showNotification(
              id: 1,
              title: "🍽️ Rekomendasi Makan Siang",
              body: "${restaurant['name']} di ${restaurant['city']} ⭐ ${restaurant['rating']}",
              payload: restaurant['id'],
              channelId: "daily_reminder",
              channelName: "Daily Reminder",
            );
          }
        }
      } catch (e) {
        print("Error fetching restaurant: $e");
      }
    }
    return Future.value(true);
  });
}

class WorkManagerService {
  final Workmanager _workmanager;

  WorkManagerService([Workmanager? workmanager])
    : _workmanager = workmanager ?? Workmanager();

  Future<void> init() async {
    await _workmanager.initialize(callbackDispatcher);
  }

  /// Jalankan task periodic untuk daily reminder
  /// Akan berjalan setiap 15 menit (minimum interval di Android)
  Future<void> runDailyReminderTask() async {
    await _workmanager.registerPeriodicTask(
      MyWorkmanager.periodic.uniqueName,
      MyWorkmanager.periodic.taskName,
      constraints: Constraints(networkType: NetworkType.connected),
      frequency: const Duration(hours: 24),
      initialDelay: _calculateInitialDelay(),
    );
  }

  /// Hitung delay sampai jam 11:00
  Duration _calculateInitialDelay() {
    final now = DateTime.now();
    var scheduledTime = DateTime(now.year, now.month, now.day, 11, 0);
    
    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }
    
    return scheduledTime.difference(now);
  }

  Future<void> cancelAllTask() async {
    await _workmanager.cancelAll();
  }
}
```

### Step 2.2: Update `local_notification_provider.dart`

**File**: `lib/provider/notification/local_notification_provider.dart`

**Perubahan yang diperlukan**:
- Integrasikan dengan WorkManagerService
- Gunakan WorkManager untuk scheduling daripada scheduled notification

```dart
import 'package:flutter/material.dart';
import 'package:restaurant_app/services/local_notification_service.dart';
import 'package:restaurant_app/services/shared_preferences_service.dart';
import 'package:restaurant_app/services/work_manager_service.dart';

class LocalNotificationProvider extends ChangeNotifier {
  final LocalNotificationService flutterNotificationService;
  final SharedPreferencesService sharedPreferencesService;
  final WorkManagerService workManagerService;

  LocalNotificationProvider(
    this.flutterNotificationService,
    this.sharedPreferencesService,
    this.workManagerService,
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
      // Gunakan WorkManager untuk schedule daily reminder
      await workManagerService.runDailyReminderTask();
      await sharedPreferencesService.saveDailyReminder(true);
      _isDailyReminderActive = true;
      notifyListeners();
    }
  }

  Future<void> disableDailyReminder() async {
    await workManagerService.cancelAllTask();
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
```

### Step 2.3: Update `main.dart`

**File**: `lib/main.dart`

**Perubahan yang diperlukan**:
- Inject WorkManagerService ke LocalNotificationProvider

```dart
ChangeNotifierProvider(
  create: (context) => LocalNotificationProvider(
    context.read<LocalNotificationService>(),
    context.read<SharedPreferencesService>(),
    context.read<WorkManagerService>(),
  ),
),
```

### Step 2.4: Update `setting_screen.dart`

**File**: `lib/screen/setting/setting_screen.dart`

**Perubahan yang diperlukan**:
- Hapus fungsi yang tidak digunakan
- Simplifikasi logic toggle

```dart
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
          // Dark Theme Toggle
          Consumer<SharedPreferencesProvider>(
            builder: (context, provider, child) => ListTile(
              title: const Text('Dark Theme'),
              trailing: Switch(
                value: provider.isDarkTheme,
                onChanged: (value) => context
                    .read<SharedPreferencesProvider>()
                    .saveThemeValue(value),
              ),
            ),
          ),
          
          // Daily Reminder Toggle
          Consumer<LocalNotificationProvider>(
            builder: (context, provider, child) => ListTile(
              title: const Text('Daily Notification at 11:00 AM'),
              subtitle: const Text('Reminder untuk makan siang dengan rekomendasi restoran'),
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
        ],
      ),
    );
  }
}
```

---

## 📱 Cara Test

### Test Manual

1. **Build dan Run Aplikasi**
   ```bash
   flutter run
   ```

2. **Test Enable Daily Reminder**
   - Buka Settings
   - Aktifkan switch "Daily Notification at 11:00 AM"
   - Pastikan tidak ada error

3. **Test Disable Daily Reminder**
   - Matikan switch
   - Pastikan tidak ada error

4. **Test Notifikasi (Untuk testing cepat)**
   - Ubah `initialDelay` di WorkManager ke 10 detik
   - Aktifkan reminder
   - Tunggu 10 detik, notifikasi akan muncul dengan info restoran random

5. **Test Persistence**
   - Aktifkan reminder
   - Close app sepenuhnya
   - Buka ulang app
   - Pastikan switch masih dalam posisi aktif

### Verifikasi Shared Preferences

- Aktifkan/matikan reminder
- Restart app
- Status switch harus sesuai dengan terakhir kali diubah

---

## ⚠️ Catatan Penting

1. **WorkManager Minimum Interval**: Di Android, interval minimum adalah 15 menit. Untuk testing, gunakan `initialDelay` yang pendek.

2. **Background Execution**: WorkManager akan tetap berjalan meskipun app di-close, selama ada koneksi internet (constraint: `NetworkType.connected`).

3. **iOS Limitation**: WorkManager memiliki keterbatasan di iOS. Untuk iOS, pertimbangkan menggunakan scheduled local notification sebagai fallback.

4. **API Dependency**: Pastikan device memiliki koneksi internet saat notifikasi dijadwalkan karena perlu fetch data dari API.

---

## 📁 Summary File yang Dimodifikasi

| File | Action |
|------|--------|
| `lib/services/work_manager_service.dart` | MODIFY - Fetch restaurant API & show notification |
| `lib/provider/notification/local_notification_provider.dart` | MODIFY - Integrate WorkManager |
| `lib/main.dart` | MODIFY - Inject WorkManagerService |
| `lib/screen/setting/setting_screen.dart` | MODIFY - Simplify & clean up |
