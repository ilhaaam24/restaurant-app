sealed class AddFavoriteRestaurantState {}

class AddFavoriteRestaurantInitial extends AddFavoriteRestaurantState {}

class AddFavoriteRestaurantLoading extends AddFavoriteRestaurantState {}

class AddFavoriteRestaurantSuccess extends AddFavoriteRestaurantState {
  final String message;

  AddFavoriteRestaurantSuccess(this.message);
}

class AddFavoriteRestaurantError extends AddFavoriteRestaurantState {
  final String error;

  AddFavoriteRestaurantError(this.error);
}
