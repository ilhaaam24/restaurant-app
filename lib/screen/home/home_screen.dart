import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/home/restaurant_list_provider.dart';
import 'package:restaurant_app/screen/home/restaurant_card.dart';
import 'package:restaurant_app/static/navigation_route.dart';
import 'package:restaurant_app/static/restaurant_list_result_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    final provider = context.read<RestaurantListProvider>();
    Future.microtask(() {
      provider.fetchRestaurantList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Restaurant App")),
      backgroundColor: Theme.of(context).colorScheme.onSecondary,
      body: Consumer<RestaurantListProvider>(
        builder: (context, value, child) {
          return switch (value.resultState) {
            RestaurantListNoneState() => const SizedBox(),
            RestaurantListLoadingState() => const Center(
              child: CircularProgressIndicator(),
            ),
            RestaurantListErrorState(error: var error) => Center(
              child: Text(error),
            ),
            RestaurantListLoadedState(data: var restaurantList) =>
              ListView.builder(
                shrinkWrap: true,
                itemCount: restaurantList.length,
                itemBuilder: (context, index) {
                  final restaurant = restaurantList[index];
                  return RestaurantCard(
                    onTap: () => Navigator.pushNamed(
                      context,
                      NavigationRoute.detailRoute.path,
                      arguments: restaurant.id,
                    ),
                    restaurant: restaurant,
                  );
                },
              ),
          };
        },
      ),
    );
  }
}
