import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:mumiappfood/core/services/auth_service.dart';
import 'package:mumiappfood/features/review/data/models/review_model.dart';
import 'package:mumiappfood/features/review/data/repositories/review_repository.dart';
import 'package:mumiappfood/features/review/state/review_state.dart';

class ReviewCubit extends Cubit<ReviewState> {
  final ReviewRepository _reviewRepository;
  late StreamSubscription _authSubscription;

  // SỬA LỖI: Xóa bỏ AuthCubit không tồn tại
  ReviewCubit(this._reviewRepository) : super(ReviewInitial()) {
    // SỬA LỖI: Lắng nghe trực tiếp từ AuthService.authStateChanges
    _authSubscription = AuthService.authStateChanges.listen((isAuthenticated) {
      if (!isAuthenticated) {
        // Nếu người dùng đã đăng xuất, reset state của cubit này
        emit(ReviewInitial());
      }
    });
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }

  Future<void> fetchReviews(int restaurantId, {bool isRefresh = false}) async {
    if (await AuthService.getAccessToken() == null) {
      emit(const ReviewsLoaded(reviews: [], currentPage: 1, totalPages: 1, hasReachedMax: true));
      return;
    }

    if (state is ReviewLoading && !isRefresh) return;

    emit(ReviewLoading());

    try {
      final response = await _reviewRepository.getReviewsByRestaurant(
        restaurantId: restaurantId,
        page: 1, 
      );
      if (response != null) {
        final reviews = (response['items'] as List).map((i) => Review.fromMap(i as Map<String, dynamic>)).toList();
        final totalPages = response['totalPages'] as int;

        emit(ReviewsLoaded(
          reviews: reviews,
          currentPage: 1,
          totalPages: totalPages,
          hasReachedMax: 1 >= totalPages,
        ));
      } else {
        emit(const ReviewsLoaded(reviews: [], currentPage: 1, totalPages: 1, hasReachedMax: true));
      }
    } catch (e) {
      emit(ReviewError(e.toString()));
    }
  }

  Future<void> fetchMoreReviews(int restaurantId) async {
    final currentState = state;
    if (currentState is! ReviewsLoaded || currentState.isLoadingMore || currentState.hasReachedMax) {
      return;
    }

    emit(currentState.copyWith(isLoadingMore: true));

    try {
      final nextPage = currentState.currentPage + 1;
      final response = await _reviewRepository.getReviewsByRestaurant(
        restaurantId: restaurantId,
        page: nextPage,
      );

      if (response != null) {
        final newReviews = (response['items'] as List).map((i) => Review.fromMap(i as Map<String, dynamic>)).toList();
        final totalPages = response['totalPages'] as int;

        emit(currentState.copyWith(
          reviews: List.of(currentState.reviews)..addAll(newReviews),
          currentPage: nextPage,
          hasReachedMax: nextPage >= totalPages,
          isLoadingMore: false,
        ));
      } else {
        emit(currentState.copyWith(isLoadingMore: false, hasReachedMax: true));
      }
    } catch (e) {
      emit(currentState.copyWith(isLoadingMore: false));
    }
  }

  Future<void> submitReview({
    required int restaurantId,
    required double rating,
    required String comment,
  }) async {
    emit(ReviewSubmitting());
    try {
      await _reviewRepository.addReview(
        restaurantId: restaurantId,
        rating: rating.toInt(),
        comment: comment,
      );
      
      await fetchReviews(restaurantId, isRefresh: true);

    } catch (e) {
      emit(ReviewSubmitError(e.toString()));
    }
  }

  Future<void> updateReview({
    required int reviewId,
    required double rating,
    required String comment,
    required int restaurantId,
  }) async {
    emit(ReviewUpdating());
    try {
      await _reviewRepository.updateReview(
        reviewId: reviewId,
        rating: rating.toInt(),
        comment: comment,
      );

      await fetchReviews(restaurantId, isRefresh: true);

    } catch (e) {
      emit(ReviewUpdateError(e.toString()));
    }
  }

  Future<void> deleteReview(int reviewId, int restaurantId) async {
    final currentState = state;
    if (currentState is! ReviewsLoaded) return;

    emit(currentState.copyWith(reviews: currentState.reviews.where((r) => r.id != reviewId).toList()));

    try {
      await _reviewRepository.deleteReview(reviewId);
      await fetchReviews(restaurantId, isRefresh: true);
    } catch (e) {
      emit(currentState); 
      emit(ReviewError("Không thể xóa đánh giá: ${e.toString()}"));
    }
  }
}
