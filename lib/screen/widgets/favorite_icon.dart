import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/model/restaurant_model.dart';
import 'package:restaurant_app/provider/local_database/local_database_provider.dart';

class FavoriteIcon extends StatelessWidget {
  final Restaurant restaurant;

  const FavoriteIcon({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocalDatabaseProvider>(
      builder: (context, provider, _) {
        final isFavorite =
            provider.restaurantList?.any((r) => r.id == restaurant.id) ?? false;

        return IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : Colors.black,
          ),
          onPressed: () async {
            if (isFavorite) {
              await provider.deleteValue(restaurant.id);
            } else {
              await provider.saveRestaurantValue(restaurant);
            }

            // await LocalNotificationService().showNotification(
            //   id: 1,
            //   title: "Haloo",
            //   body: "Halo ini adalah notif",
            //   payload: "Halo ini adalah notif",
            // );

            await provider.getAllRestaurantValue();
            if (!context.mounted) return;
            final snackBar = SnackBar(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              content: Text(provider.message),
              duration: Duration(seconds: 2),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
        );
      },
    );
  }
}
