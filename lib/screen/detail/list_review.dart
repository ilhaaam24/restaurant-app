import 'package:flutter/material.dart';
import 'package:restaurant_app/model/restaurant_detail_model.dart';

class ListReview extends StatelessWidget {
  const ListReview({super.key, required this.restaurant});

  final RestaurantDetail restaurant;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Reviews', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox.square(dimension: 8),
        SizedBox(
          child: Wrap(
            runSpacing: 8.0,

            children: [
              for (var review in restaurant.customerReviews)
                ListTile(
                  leading: Icon(Icons.person, size: 32.0),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.all(
                      Radius.circular(8.0),
                    ),
                  ),
                  tileColor: Theme.of(context).colorScheme.primaryContainer,

                  title: Text(
                    review.name,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  subtitle: Text(
                    review.review,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  trailing: Text(
                    review.date,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
