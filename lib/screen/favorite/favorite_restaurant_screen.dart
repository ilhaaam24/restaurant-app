import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/local_database/local_database_provider.dart';
import 'package:restaurant_app/screen/home/restaurant_card.dart';
import 'package:restaurant_app/static/navigation_route.dart';

class FavoriteRestaurantScreen extends StatefulWidget {
  const FavoriteRestaurantScreen({super.key});

  @override
  State<FavoriteRestaurantScreen> createState() =>
      _FavoriteRestaurantScreenState();
}

class _FavoriteRestaurantScreenState extends State<FavoriteRestaurantScreen> {
  @override
  void initState() {
    super.initState();
    final provider = context.read<LocalDatabaseProvider>();
    Future.microtask(() {
      provider.getAllRestaurantValue();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorite Restaurants')),
      body: Consumer<LocalDatabaseProvider>(
        builder: (context, value, child) {
          final favoriteRestaurants = value.restaurantList;
          return switch (favoriteRestaurants!.isNotEmpty) {
            true => ListView.builder(
              itemCount: favoriteRestaurants.length,
              itemBuilder: (context, index) {
                final restaurant = favoriteRestaurants[index];
                return RestaurantCard(
                  restaurant: restaurant,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      NavigationRoute.detailRoute.path,
                      arguments: restaurant.id,
                    );
                  },
                );
              },
            ),
            false => const Center(
              child: Text('No favorite restaurants found.'),
            ),
          };
        },
      ),
    );
  }
}
