import 'package:restaurant_app/model/search_restaurant_response_model.dart';

sealed class SearchResultState {}

class SearchResultNoneState extends SearchResultState {}

class SearchResultLoadingState extends SearchResultState {}

class SearchResultErrorState extends SearchResultState {
  final String error;
  SearchResultErrorState(this.error);
}

class SearchResultLoadedState extends SearchResultState {
  final SearchRestaurantResponse data;
  SearchResultLoadedState(this.data);
}
