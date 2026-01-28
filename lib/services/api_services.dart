import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:restaurant_app/model/add_review_response_mode.dart';
import 'package:restaurant_app/model/restaurant_detail_response_model.dart';
import 'package:restaurant_app/model/restaurant_list_response_model.dart';
import 'package:http/http.dart' as http;
import 'package:restaurant_app/model/search_restaurant_response_model.dart';

class ApiServices {
  static const String _baseUrl = "https://restaurant-api.dicoding.dev";

  Future<RestaurantListResponse> getRestaurantList() async {
    try {
      final res = await http.get(Uri.parse("$_baseUrl/list"));

      if (res.statusCode == 200) {
        return restaurantListResponseFromJson(res.body);
      } else {
        throw ('Failed to load restaurant list');
      }
    } catch (e) {
      if (e is SocketException) {
        throw ('No Internet Connection. Please try again later.');
      } else if (e is TimeoutException) {
        throw ('Request timed out. Please try again later.');
      } else if (e is FormatException) {
        throw ('Failed to load response data.');
      } else {
        throw ("Caught an error: $e");
      }
    }
  }

  Future<RestaurantDetailResponse> getRestaurantById(String id) async {
    try {
      final res = await http.get(Uri.parse("$_baseUrl/detail/$id"));

      if (res.statusCode == 200) {
        return restaurantDetailResponseFromJson(res.body);
      } else {
        throw ('Failed to load restaurant detail');
      }
    } catch (e) {
      if (e is SocketException) {
        throw ('No Internet Connection. Please try again later.');
      } else if (e is TimeoutException) {
        throw ('Request timed out. Please try again later.');
      } else if (e is FormatException) {
        throw ('Failed to load response data.');
      } else {
        throw ("Caught an error: $e");
      }
    }
  }

  Future<AddReviewResponse> addReview(
    String restaurantid,
    String name,
    String review,
  ) async {
    try {
      final res = await http.post(
        Uri.parse("$_baseUrl/review"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"id": restaurantid, "name": name, "review": review}),
      );

      if (res.statusCode == 201) {
        return addReviewResponseFromJson(res.body);
      } else {
        throw ('Failed to add review');
      }
    } catch (e) {
      if (e is SocketException) {
        throw ('No Internet Connection. Please try again later.');
      } else if (e is TimeoutException) {
        throw ('Request timed out. Please try again later.');
      } else if (e is FormatException) {
        throw ('Failed to load response data.');
      } else {
        throw ("Caught an error: $e");
      }
    }
  }

  Future<SearchRestaurantResponse> searchRestaurant(String query) async {
    try {
      final res = await http.get(Uri.parse("$_baseUrl/search?q=$query"));

      if (res.statusCode == 200) {
        return searchRestaurantResponseFromJson(res.body);
      } else {
        throw ('Failed to search restaurant');
      }
    } catch (e) {
      if (e is SocketException) {
        throw ('No Internet Connection. Please try again later.');
      } else if (e is TimeoutException) {
        throw ('Request timed out. Please try again later.');
      } else if (e is FormatException) {
        throw ('Failed to load response data.');
      } else {
        throw ("Caught an error: $e");
      }
    }
  }

  Future<String> getDataFromUrl(String url) async {
    final response = await http.get(Uri.parse(url));
    return response.body;
  }
}
