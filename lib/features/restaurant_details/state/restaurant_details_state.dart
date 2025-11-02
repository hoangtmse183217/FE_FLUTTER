import 'package:flutter/foundation.dart';
import 'package:mumiappfood/features/post/data/models/post_model.dart';
import 'package:mumiappfood/features/restaurant/data/models/restaurant_model.dart';
import 'package:mumiappfood/features/review/data/models/review_model.dart';

@immutable
abstract class RestaurantDetailsState {
  const RestaurantDetailsState();
}

class RestaurantDetailsInitial extends RestaurantDetailsState {}

class RestaurantDetailsLoading extends RestaurantDetailsState {}

class RestaurantDetailsLoaded extends RestaurantDetailsState {
  final Restaurant restaurant;
  final List<Post> posts;

  const RestaurantDetailsLoaded({required this.restaurant, this.posts = const []});

  RestaurantDetailsLoaded copyWith({
    Restaurant? restaurant,
    List<Post>? posts,
  }) {
    return RestaurantDetailsLoaded(
      restaurant: restaurant ?? this.restaurant,
      posts: posts ?? this.posts,
    );
  }
}

class RestaurantDetailsError extends RestaurantDetailsState {
  final String message;
  const RestaurantDetailsError({required this.message});
}

// States for submitting a new review
class RestaurantReviewSubmitting extends RestaurantDetailsState {}
class RestaurantReviewSuccess extends RestaurantDetailsState {}
class RestaurantReviewError extends RestaurantDetailsState {
  final String message;
  const RestaurantReviewError({required this.message});
}

// THÊM MỚI: States for updating a review
class RestaurantReviewUpdating extends RestaurantDetailsState {}

class RestaurantReviewUpdateSuccess extends RestaurantDetailsState {
  final Review updatedReview;
  const RestaurantReviewUpdateSuccess(this.updatedReview);
}

class RestaurantReviewUpdateError extends RestaurantDetailsState {
  final String message;
  const RestaurantReviewUpdateError({required this.message});
}
