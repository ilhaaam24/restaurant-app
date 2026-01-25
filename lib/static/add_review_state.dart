import 'package:restaurant_app/model/add_review_response_mode.dart';

sealed class AddReviewState {}

class AddReviewNoneState extends AddReviewState {}

class AddReviewLoadingState extends AddReviewState {}

class AddReviewErrorState extends AddReviewState {
  final String error;
  AddReviewErrorState(this.error);
}

class AddReviewSuccessState extends AddReviewState {
  final AddReviewResponse data;
  AddReviewSuccessState(this.data);
}
