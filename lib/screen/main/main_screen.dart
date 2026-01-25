import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/main/main_provider.dart';
import 'package:restaurant_app/screen/favorite/favorite_restaurant_screen.dart';
import 'package:restaurant_app/screen/home/home_screen.dart';
import 'package:restaurant_app/screen/search_screen.dart';
import 'package:restaurant_app/screen/setting/setting_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<MainProvider>(
        builder: (context, value, child) {
          return switch (value.indexBottomNavBar) {
            0 => HomeScreen(),
            1 => SearchScreen(),
            2 => FavoriteRestaurantScreen(),
            3 => SettingScreen(),
            _ => HomeScreen(),
          };
        },
      ),

      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Theme.of(context).colorScheme.onSurface,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        selectedLabelStyle: TextStyle(
          color: Theme.of(context).colorScheme.primary,
        ),
        unselectedLabelStyle: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
        ),
        iconSize: 28,
        showUnselectedLabels: true,
        showSelectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Favorite",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
        currentIndex: context.watch<MainProvider>().indexBottomNavBar,
        onTap: (value) {
          context.read<MainProvider>().setIndextBottomNavBar = value;
        },
      ),
    );
  }
}
