import 'package:mumiappfood/features/review/data/providers/review_api_provider.dart';

class ReviewRepository {
  final ReviewApiProvider _apiProvider;

  ReviewRepository({ReviewApiProvider? apiProvider})
      : _apiProvider = apiProvider ?? ReviewApiProvider();

  Future<Map<String, dynamic>> getReviewsByRestaurant({
    required int restaurantId,
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final response = await _apiProvider.getReviewsByRestaurant(
        restaurantId: restaurantId,
        page: page,
        pageSize: pageSize,
      );
      // SỬA LỖI: Xử lý an toàn trường hợp data là null, trả về cấu trúc phân trang rỗng
      return response['data'] as Map<String, dynamic>? ?? {'items': [], 'page': page, 'totalPages': 0};
    } on ReviewApiException {
      rethrow;
    }
  }

  // SỬA LỖI TRIỆT ĐỂ: Cho phép phương thức trả về null
  Future<Map<String, dynamic>?> addReview({
    required int restaurantId,
    required int rating,
    required String comment,
  }) async {
    try {
      final response = await _apiProvider.addReview(
        restaurantId: restaurantId,
        rating: rating,
        comment: comment,
      );
      // SỬA LỖI TRIỆT ĐỂ: Ép kiểu an toàn, cho phép kết quả là null
      return response['data'] as Map<String, dynamic>?;
    } on ReviewApiException {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateReview({
    required int reviewId,
    required int rating,
    required String comment,
  }) async {
    try {
      final response = await _apiProvider.updateReview(
        reviewId: reviewId,
        rating: rating,
        comment: comment,
      );
      // Sửa lỗi: Vẫn nên có kiểm tra null để phòng thủ, dù API spec nói là có data
      final data = response['data'] as Map<String, dynamic>?;
      if (data == null) {
        throw ReviewApiException("Không nhận được dữ liệu đánh giá đã cập nhật từ máy chủ.");
      }
      return data;
    } on ReviewApiException {
      rethrow;
    }
  }

  Future<void> deleteReview(int reviewId) async {
    try {
      await _apiProvider.deleteReview(reviewId);
    } on ReviewApiException {
      rethrow;
    }
  }
}
