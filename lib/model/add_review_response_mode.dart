import 'dart:convert';

import 'package:restaurant_app/model/customer_review_model.dart';

AddReviewResponse addReviewResponseFromJson(String str) =>
    AddReviewResponse.fromJson(json.decode(str));

class AddReviewResponse {
  bool error;
  String message;
  List<CustomerReview> customerReviews;

  AddReviewResponse({
    required this.error,
    required this.message,
    required this.customerReviews,
  });

  factory AddReviewResponse.fromJson(Map<String, dynamic> json) =>
      AddReviewResponse(
        error: json["error"],
        message: json["message"],
        customerReviews: List<CustomerReview>.from(
          json["customerReviews"].map((x) => CustomerReview.fromJson(x)),
        ),
      );
}
