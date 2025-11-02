import 'package:flutter/foundation.dart';
import 'package:mumiappfood/features/review/data/models/review_model.dart';

@immutable
abstract class ReviewState {
  const ReviewState();
}

class ReviewInitial extends ReviewState {}

class ReviewLoading extends ReviewState {}

class ReviewsLoaded extends ReviewState {
  final List<Review> reviews;
  final int currentPage;
  final int totalPages;
  final bool hasReachedMax;
  final bool isLoadingMore;

  const ReviewsLoaded({
    required this.reviews,
    required this.currentPage,
    required this.totalPages,
    required this.hasReachedMax,
    this.isLoadingMore = false,
  });

  ReviewsLoaded copyWith({
    List<Review>? reviews,
    int? currentPage,
    int? totalPages,
    bool? hasReachedMax,
    bool? isLoadingMore,
  }) {
    return ReviewsLoaded(
      reviews: reviews ?? this.reviews,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class ReviewError extends ReviewState {
  final String message;
  const ReviewError(this.message);
}

class ReviewSubmitting extends ReviewState {}

class ReviewSubmitSuccess extends ReviewState {
  final Review newReview;
  const ReviewSubmitSuccess(this.newReview);
}

class ReviewSubmitError extends ReviewState {
  final String message;
  const ReviewSubmitError(this.message);
}

// THÊM MỚI: States cho việc cập nhật review
class ReviewUpdating extends ReviewState {}

class ReviewUpdateSuccess extends ReviewState {
  final Review updatedReview;
  const ReviewUpdateSuccess(this.updatedReview);
}

class ReviewUpdateError extends ReviewState {
  final String message;
  const ReviewUpdateError(this.message);
}
