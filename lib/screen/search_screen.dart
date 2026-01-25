import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/search/search_provider.dart';
import 'package:restaurant_app/screen/home/restaurant_card.dart';
import 'package:restaurant_app/static/navigation_route.dart';
import 'package:restaurant_app/static/search_result_state.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Search Restaurant")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Search",
                    ),
                  ),
                ),
                SizedBox.square(dimension: 24),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      context.read<SearchProvider>().searchRestaurant(
                        _searchController.text,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox.square(dimension: 24),
          Expanded(
            child: Consumer<SearchProvider>(
              builder: (context, provider, child) {
                return switch (provider.resultState) {
                  SearchResultNoneState() => const Center(
                    child: Text("No Data Restaurant"),
                  ),
                  SearchResultLoadingState() => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  SearchResultLoadedState(data: var data) => ListView.builder(
                    itemCount: data.restaurants.length,
                    itemBuilder: (context, index) {
                      final restaurant = data.restaurants[index];
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
                  SearchResultErrorState(error: var error) => Center(
                    child: Text(error),
                  ),
                };
              },
            ),
          ),
        ],
      ),
    );
  }
}
