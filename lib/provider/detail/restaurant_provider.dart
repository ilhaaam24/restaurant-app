import 'package:flutter/material.dart';
import 'package:restaurant_app/services/api_services.dart';
import 'package:restaurant_app/model/customer_review_model.dart';
import 'package:restaurant_app/static/restaurant_detail_result_state.dart';

class RestaurantDetailProvider extends ChangeNotifier {
  final ApiServices apiServices;

  RestaurantDetailProvider({required this.apiServices});

  RestaurantDetailResultState _resultState = RestaurantDetailNoneState();

  RestaurantDetailResultState get resultState => _resultState;

  Future<void> fetchRestaurantDetail(String id) async {
    try {
      _resultState = RestaurantDetailLoadingState();
      notifyListeners();
      final result = await apiServices.getRestaurantById(id);

      if (result.error) {
        _resultState = RestaurantDetailErrorState(result.message);
        notifyListeners();
      } else {
        _resultState = RestaurantDetailLoadedState(result.restaurant);
        notifyListeners();
      }
    } catch (e) {
      _resultState = RestaurantDetailErrorState(e.toString());
      notifyListeners();
    }
  }

  void updateCustomerReviews(List<CustomerReview> reviews) {
    if (_resultState is RestaurantDetailLoadedState) {
      final restaurant = (_resultState as RestaurantDetailLoadedState).data;
      restaurant.customerReviews = reviews;
      _resultState = RestaurantDetailLoadedState(restaurant);
      notifyListeners();
    }
  }
}
