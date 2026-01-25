import 'package:flutter/material.dart';
import 'package:restaurant_app/model/restaurant_detail_model.dart';

class ListMenu extends StatelessWidget {
  const ListMenu({super.key, required this.restaurant, required this.title});
  final String title;
  final RestaurantDetail restaurant;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox.square(dimension: 8),
        ConstrainedBox(
          constraints: const BoxConstraints(
            maxHeight: 120,
            minHeight: 120,
            maxWidth: double.infinity,
            minWidth: double.infinity,
          ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: restaurant.menus.foods.length,
            itemBuilder: (context, index) {
              final food = restaurant.menus.foods[index];
              return ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 120,
                  minHeight: 120,
                  maxWidth: 120,
                  minWidth: 120,
                ),
                child: Container(
                  margin: const EdgeInsets.only(right: 8.0),
                  padding: const EdgeInsets.symmetric(
                    vertical: 4.0,
                    horizontal: 8.0,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.fastfood,
                        size: 24.0,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                      SizedBox.square(dimension: 8),
                      Text(
                        food.name,
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
