import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/detail/restaurant_provider.dart';
import 'package:restaurant_app/provider/home/restaurant_list_provider.dart';
import 'package:restaurant_app/provider/local_database/local_database_provider.dart';
import 'package:restaurant_app/provider/main/main_provider.dart';
import 'package:restaurant_app/provider/notification/local_notification_provider.dart';
import 'package:restaurant_app/provider/review/add_review_provider.dart';
import 'package:restaurant_app/provider/search/search_provider.dart';
import 'package:restaurant_app/provider/theme/shared_preferences_provider.dart';
import 'package:restaurant_app/screen/detail/restaurant_detail.dart';
import 'package:restaurant_app/screen/main/main_screen.dart';
import 'package:restaurant_app/screen/search_screen.dart';
import 'package:restaurant_app/services/api_services.dart';
import 'package:restaurant_app/services/local_notification_service.dart';
import 'package:restaurant_app/services/shared_preferences_service.dart';
import 'package:restaurant_app/services/sqlite_service.dart';
import 'package:restaurant_app/static/navigation_route.dart';
import 'package:restaurant_app/style/theme/restaurant_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MainProvider()),
        ChangeNotifierProvider(
          create: (_) => RestaurantDetailProvider(apiServices: ApiServices()),
        ),
        ChangeNotifierProvider(
          create: (context) => SearchProvider(apiServices: ApiServices()),
        ),
        ChangeNotifierProvider(
          create: (_) => AddReviewProvider(apiServices: ApiServices()),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              RestaurantDetailProvider(apiServices: ApiServices()),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              RestaurantListProvider(apiServices: ApiServices()),
        ),
        Provider(create: (context) => SharedPreferencesService(prefs)),
        ChangeNotifierProvider(
          create: (context) => SharedPreferencesProvider(
            context.read<SharedPreferencesService>(),
          ),
        ),

        Provider(create: (context) => SqliteService()),
        ChangeNotifierProvider(
          create: (context) {
            return LocalDatabaseProvider(context.read<SqliteService>());
          },
        ),

        Provider(create: (context) => LocalNotificationService()..init()),
        ChangeNotifierProvider(
          create: (context) => LocalNotificationProvider(
            context.read<LocalNotificationService>(),
          )..requestPermissions(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SharedPreferencesProvider>(
      builder: (context, value, child) {
        return MaterialApp(
          theme: RestaurantTheme.lightTheme,
          darkTheme: RestaurantTheme.darkTheme,
          themeMode: value.isDarkTheme ? ThemeMode.dark : ThemeMode.light,
          title: 'Restaurant App',
          initialRoute: NavigationRoute.mainRoute.path,
          routes: {
            NavigationRoute.mainRoute.path: (context) => MainScreen(),
            NavigationRoute.detailRoute.path: (context) {
              final args = ModalRoute.of(context)?.settings.arguments;
              if (args is String) {
                return RestaurantDetail(id: args);
              }
              return const Scaffold(
                body: Center(child: Text('Error: Restaurant ID is missing')),
              );
            },
            NavigationRoute.searchRoute.path: (context) => const SearchScreen(),
          },
        );
      },
    );
  }
}
