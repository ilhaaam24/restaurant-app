import 'package:flutter/material.dart';
import 'package:restaurant_app/helper/shared_value.dart';
import 'package:restaurant_app/model/restaurant_detail_model.dart';
import 'package:restaurant_app/screen/detail/dialog_add_review.dart';
import 'package:restaurant_app/screen/detail/list_category.dart';
import 'package:restaurant_app/screen/detail/list_menu.dart';
import 'package:restaurant_app/screen/detail/list_review.dart';

class BodyOfDetailScreen extends StatelessWidget {
  const BodyOfDetailScreen({super.key, required this.restaurant});
  final RestaurantDetail restaurant;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Hero(
          tag: restaurant.id,
          child: Image.network(
            '$imageUrl${restaurant.pictureId}',
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox.square(dimension: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant.name,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  Row(
                    children: [
                      Icon(Icons.location_on),
                      SizedBox.square(dimension: 4),
                      Expanded(
                        child: Text(
                          '${restaurant.address}, ${restaurant.city}',
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(fontWeight: FontWeight.w400),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.yellow),
                const SizedBox.square(dimension: 4),
                Text(
                  restaurant.rating.toString(),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ],
        ),
        const SizedBox.square(dimension: 16),
        ListCategory(restaurant: restaurant),
        const SizedBox.square(dimension: 16),
        Text(
          restaurant.description,
          style: Theme.of(context).textTheme.bodyLarge,
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox.square(dimension: 16),
        ListMenu(restaurant: restaurant, title: 'List Food'),
        const SizedBox.square(dimension: 16),
        ListMenu(restaurant: restaurant, title: 'List Drink'),
        const SizedBox.square(dimension: 16),
        ListReview(restaurant: restaurant),
        const SizedBox.square(dimension: 8),
        FilledButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) =>
                  AddReviewDialog(restaurantId: restaurant.id),
            );
          },
          child: Text(
            "Add Review",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSecondary,
            ),
          ),
        ),
        const SizedBox.square(dimension: 16),
      ],
    );
  }
}
