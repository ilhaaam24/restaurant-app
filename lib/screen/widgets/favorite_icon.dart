import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/model/restaurant_model.dart';
import 'package:restaurant_app/provider/detail/favorite_icon_provider.dart';
import 'package:restaurant_app/provider/local_database/local_database_provider.dart';

class FavoriteIcon extends StatefulWidget {
  const FavoriteIcon({super.key, required this.restaurant});
  final Restaurant restaurant;

  @override
  State<FavoriteIcon> createState() => _FavoriteIconState();
}

class _FavoriteIconState extends State<FavoriteIcon> {
  @override
  void initState() {
    final LocalDatabaseProvider provider = context
        .read<LocalDatabaseProvider>();

    final FavoriteIconProvider favoriteIconProvider = context
        .read<FavoriteIconProvider>();

    Future.microtask(() async {
      final restaurantInFavorite = await provider.checkFavoriteStatus(
        widget.restaurant.id,
      );

      favoriteIconProvider.isFavorite = restaurantInFavorite;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoriteIconProvider>(
      builder: (context, provider, child) {
        final localDatabaseProvider = context.read<LocalDatabaseProvider>();
        final favoriteIconProvider = context.read<FavoriteIconProvider>();
        final isFavorite = favoriteIconProvider.isFavorite;
        return IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : Colors.black,
          ),
          onPressed: () async {
            if (!isFavorite) {
              await localDatabaseProvider.saveRestaurantValue(
                widget.restaurant,
              );
            } else {
              await localDatabaseProvider.deleteValue(widget.restaurant.id);
            }
            await localDatabaseProvider.getAllRestaurantValue();

            favoriteIconProvider.isFavorite = !isFavorite;
          },
        );
      },
    );
  }
}
