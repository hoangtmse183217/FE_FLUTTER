part of 'feedback_cubit.dart';

@immutable
abstract class FeedbackState {
  final List<dynamic> restaurants;
  final String? selectedRestaurantId;
  final List<dynamic> reviews;

  const FeedbackState({
    this.restaurants = const [],
    this.selectedRestaurantId,
    this.reviews = const [],
  });
}

class FeedbackInitial extends FeedbackState {}

class FeedbackLoading extends FeedbackState {
  const FeedbackLoading({super.restaurants, super.selectedRestaurantId, super.reviews});
}

class FeedbackError extends FeedbackState {
  final String message;
  final bool? isActionError;

  const FeedbackError(
    this.message, {
    this.isActionError,
    super.restaurants,
    super.selectedRestaurantId,
    super.reviews,
  });
}

class FeedbackLoaded extends FeedbackState {
  final int currentPage;
  final int totalPages;
  final bool isReplying;

  const FeedbackLoaded({
    required super.restaurants,
    required super.selectedRestaurantId,
    required super.reviews,
    this.currentPage = 1,
    this.totalPages = 1,
    this.isReplying = false,
  });

  FeedbackLoaded copyWith({
    List<dynamic>? restaurants,
    String? selectedRestaurantId,
    List<dynamic>? reviews,
    int? currentPage,
    int? totalPages,
    bool? isReplying,
  }) {
    return FeedbackLoaded(
      restaurants: restaurants ?? this.restaurants,
      selectedRestaurantId: selectedRestaurantId ?? this.selectedRestaurantId,
      reviews: reviews ?? this.reviews,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      isReplying: isReplying ?? this.isReplying,
    );
  }
}
