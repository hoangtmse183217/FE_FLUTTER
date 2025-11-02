import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:mumiappfood/features/owner_dashboard/data/repositories/restaurant_repository.dart';
import 'package:mumiappfood/features/partner_reviews/data/repositories/review_repository.dart';

part 'feedback_state.dart';

class FeedbackCubit extends Cubit<FeedbackState> {
  final RestaurantRepository _restaurantRepository = RestaurantRepository();
  final ReviewRepository _reviewRepository = ReviewRepository();

  FeedbackCubit() : super(FeedbackInitial());

  Future<void> fetchInitialData() async {
    emit(FeedbackLoading(restaurants: state.restaurants));
    try {
      final allRestaurants = await _restaurantRepository.getMyRestaurants();
      final approvedRestaurants = allRestaurants
          .where((r) => (r['status'] as String?)?.toLowerCase() == 'approved')
          .toList();

      if (approvedRestaurants.isNotEmpty) {
        final firstRestaurantId = approvedRestaurants.first['id'].toString();
        // Tải reviews ngay sau khi có danh sách nhà hàng
        await fetchReviewsForRestaurant(firstRestaurantId, restaurants: approvedRestaurants);
      } else {
        emit(FeedbackLoaded(restaurants: [], selectedRestaurantId: null, reviews: []));
      }
    } catch (e) {
      emit(FeedbackError(e.toString(), restaurants: state.restaurants, isActionError: false));
    }
  }

  Future<void> fetchReviewsForRestaurant(String restaurantId, {List<dynamic>? restaurants}) async {
    final currentRestaurants = restaurants ?? state.restaurants;
    // Hiển thị loading nhưng vẫn giữ lại dropdown và review cũ (nếu có)
    emit(FeedbackLoading(restaurants: currentRestaurants, selectedRestaurantId: restaurantId, reviews: state.reviews));

    try {
      final reviewData = await _reviewRepository.getReviews(restaurantId, page: 1);
      emit(FeedbackLoaded(
        restaurants: currentRestaurants,
        selectedRestaurantId: restaurantId,
        reviews: reviewData['items'] as List<dynamic>,
        currentPage: reviewData['page'] as int,
        totalPages: reviewData['totalPages'] as int,
      ));
    } catch (e) {
      emit(FeedbackError(
        e.toString(),
        restaurants: currentRestaurants,
        selectedRestaurantId: restaurantId,
        reviews: state.reviews, // Giữ lại review cũ khi lỗi
        isActionError: false,
      ));
    }
  }

  Future<void> replyToReview(int reviewId, String comment) async {
    if (state is! FeedbackLoaded) return;
    final currentState = state as FeedbackLoaded;
    emit(currentState.copyWith(isReplying: true));

    try {
      final updatedReview = await _reviewRepository.replyToReview(reviewId, comment);
      final updatedList = List<dynamic>.from(currentState.reviews);
      final index = updatedList.indexWhere((r) => r['id'] == reviewId);
      if (index != -1) {
        updatedList[index] = updatedReview;
      }
      emit(currentState.copyWith(reviews: updatedList, isReplying: false));
    } catch (e) {
      // Lỗi hành động, giữ nguyên mọi thứ và báo lỗi
      emit(FeedbackError(
        e.toString(),
        restaurants: currentState.restaurants,
        selectedRestaurantId: currentState.selectedRestaurantId,
        reviews: currentState.reviews,
        isActionError: true,
      ));
      // Quay lại trạng thái loaded để người dùng có thể thử lại
      emit(currentState.copyWith(isReplying: false));
    }
  }
}
