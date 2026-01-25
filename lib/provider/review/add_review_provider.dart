import 'package:flutter/material.dart';
import 'package:restaurant_app/services/api_services.dart';
import 'package:restaurant_app/static/add_review_state.dart';

class AddReviewProvider extends ChangeNotifier {
  final ApiServices apiServices;

  AddReviewProvider({required this.apiServices});

  AddReviewState _state = AddReviewNoneState();
  AddReviewState get state => _state;

  Future<void> addreview(
    String restaurantid,
    String name,
    String review,
  ) async {
    try {
      _state = AddReviewLoadingState();
      notifyListeners();
      final result = await apiServices.addReview(restaurantid, name, review);
      _state = AddReviewSuccessState(result);
      notifyListeners();
    } catch (e) {
      _state = AddReviewErrorState(e.toString());
      notifyListeners();
    }
  }
}
