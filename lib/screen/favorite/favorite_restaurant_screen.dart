import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/local_database/local_database_provider.dart';
import 'package:restaurant_app/screen/home/restaurant_card.dart';
import 'package:restaurant_app/static/favorite_restaurant_list_static.dart';
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
          return switch (value.favoriteRestaurantListState) {
            FavoriteRestaurantListNoneState() => const Center(
              child: Text('No favorite restaurants found.'),
            ),
            FavoriteRestaurantListLoadingState() => const Center(
              child: CircularProgressIndicator(),
            ),
            FavoriteRestaurantListErrorState(message: var message) => Center(
              child: Text(message),
            ),
            FavoriteRestaurantListLoadedState(data: var data) =>
              ListView.builder(
                itemCount: data!.length,
                itemBuilder: (context, index) {
                  final restaurant = data[index];
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
          };
        },
      ),
    );
  }
}
