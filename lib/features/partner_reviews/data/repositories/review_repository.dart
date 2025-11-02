import '../providers/review_api_provider.dart';

class ReviewRepository {
  final _apiProvider = ReviewApiProvider();

  Future<Map<String, dynamic>> getReviews(String restaurantId, {int page = 1, int pageSize = 10}) {
    return _apiProvider.fetchReviews(restaurantId, page: page, pageSize: pageSize);
  }

  Future<Map<String, dynamic>> replyToReview(int reviewId, String comment) {
    return _apiProvider.replyToReview(reviewId, comment);
  }
}
