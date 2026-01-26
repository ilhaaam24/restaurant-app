import 'package:restaurant_app/model/restaurant_model.dart';

sealed class FavoriteRestaurantListStatic {}

class FavoriteRestaurantListInitial extends FavoriteRestaurantListStatic {}

class FavoriteRestaurantListLoadingState extends FavoriteRestaurantListStatic {}

class FavoriteRestaurantListErrorState extends FavoriteRestaurantListStatic {
  final String message;
  FavoriteRestaurantListErrorState(this.message);
}

class FavoriteRestaurantListLoadedState extends FavoriteRestaurantListStatic {
  final List<Restaurant> data;
  FavoriteRestaurantListLoadedState(this.data);
}
