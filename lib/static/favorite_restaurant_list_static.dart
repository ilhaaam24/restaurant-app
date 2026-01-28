import 'package:restaurant_app/model/restaurant_model.dart';

sealed class FavoriteRestaurantListState {}

class FavoriteRestaurantListNoneState extends FavoriteRestaurantListState {}

class FavoriteRestaurantListLoadingState extends FavoriteRestaurantListState {}

class FavoriteRestaurantListErrorState extends FavoriteRestaurantListState {
  final String message;
  FavoriteRestaurantListErrorState(this.message);
}

class FavoriteRestaurantListLoadedState extends FavoriteRestaurantListState {
  final List<Restaurant>? data;
  FavoriteRestaurantListLoadedState(this.data);
}
