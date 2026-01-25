import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/helper/shared_value.dart';
import 'package:restaurant_app/model/restaurant_model.dart';
import 'package:restaurant_app/provider/detail/favorite_icon_provider.dart';
import 'package:restaurant_app/screen/widgets/favorite_icon.dart';

class RestaurantCard extends StatelessWidget {
  const RestaurantCard({
    super.key,
    required this.restaurant,
    required this.onTap,
  });

  final Restaurant restaurant;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 80,
                minHeight: 80,
                maxWidth: 120,
                minWidth: 120,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Hero(
                  tag: restaurant.id,
                  child: Image.network(
                    '$imageUrl${restaurant.pictureId}',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox.square(dimension: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    restaurant.name,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox.square(dimension: 6),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16),
                      const SizedBox.square(dimension: 4),
                      Expanded(
                        child: Text(
                          restaurant.city,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox.square(dimension: 6),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox.square(dimension: 4),
                      Expanded(
                        child: Text(
                          restaurant.rating.toString(),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ChangeNotifierProvider(
              create: (context) => FavoriteIconProvider(),
              child: FavoriteIcon(restaurant: restaurant),
            ),
          ],
        ),
      ),
    );
  }
}
