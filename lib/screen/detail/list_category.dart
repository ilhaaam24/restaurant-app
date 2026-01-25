import 'package:flutter/material.dart';
import 'package:restaurant_app/model/restaurant_detail_model.dart';

class ListCategory extends StatelessWidget {
  const ListCategory({super.key, required this.restaurant});

  final RestaurantDetail restaurant;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Categories', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox.square(dimension: 8),
        SizedBox(
          height: 32,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: restaurant.categories.length,
            itemBuilder: (context, index) {
              final category = restaurant.categories[index];
              return Container(
                margin: const EdgeInsets.only(right: 8.0),
                padding: const EdgeInsets.symmetric(
                  vertical: 4.0,
                  horizontal: 8.0,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Text(
                  category.name,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
