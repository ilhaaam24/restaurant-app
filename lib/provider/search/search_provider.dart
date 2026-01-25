import 'package:flutter/material.dart';
import 'package:restaurant_app/services/api_services.dart';
import 'package:restaurant_app/static/search_result_state.dart';

class SearchProvider extends ChangeNotifier {
  final ApiServices apiServices;

  SearchProvider({required this.apiServices});

  SearchResultState _resultState = SearchResultNoneState();

  SearchResultState get resultState => _resultState;

  Future<void> searchRestaurant(String query) async {
    try {
      _resultState = SearchResultLoadingState();
      notifyListeners();
      final result = await apiServices.searchRestaurant(query);

      if (result.error) {
        _resultState = SearchResultErrorState(result.error.toString());
        notifyListeners();
      } else {
        _resultState = SearchResultLoadedState(result);
        notifyListeners();
      }
    } catch (e) {
      _resultState = SearchResultErrorState(e.toString());
      notifyListeners();
    }
  }
}
