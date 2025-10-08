import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

part 'feedback_state.dart';

// Dữ liệu giả cho các đánh giá
final List<Map<String, dynamic>> _mockReviews = [
  {
    'id': 'review1',
    'userName': 'Nguyễn Văn A',
    'userAvatarUrl': 'https://randomuser.me/api/portraits/men/1.jpg',
    'rating': 5.0,
    'comment': 'Đồ ăn rất ngon, không gian thoáng đãng. Sẽ quay lại!',
    'createdAt': DateTime.now().subtract(const Duration(hours: 5)),
    'restaurantName': 'Nhà hàng Bếp Việt của tôi',
  },
  {
    'id': 'review2',
    'userName': 'Trần Thị B',
    'userAvatarUrl': 'https://randomuser.me/api/portraits/women/2.jpg',
    'rating': 3.0,
    'comment': 'Phục vụ hơi chậm vào cuối tuần. Món ăn tạm được, không quá đặc sắc.',
    'createdAt': DateTime.now().subtract(const Duration(days: 2)),
    'restaurantName': 'Nhà hàng Bếp Việt của tôi',
  },
  {
    'id': 'review3',
    'userName': 'Lê Văn C',
    'userAvatarUrl': null, // Trường hợp không có avatar
    'rating': 4.0,
    'comment': 'Giá hơi cao nhưng chất lượng xứng đáng.',
    'createdAt': DateTime.now().subtract(const Duration(days: 4)),
    'restaurantName': 'Quán Cà Phê Chờ Duyệt',
  },
];

class FeedbackCubit extends Cubit<FeedbackState> {
  FeedbackCubit() : super(FeedbackInitial());

  // Tải danh sách đánh giá của tất cả các nhà hàng của Partner
  Future<void> fetchReviews() async {
    emit(FeedbackLoading());
    // TODO: Thay thế bằng logic gọi Firestore
    // Query: firestore.collection('reviews').where('ownerId', isEqualTo: currentUser.uid).orderBy('createdAt', descending: true)
    await Future.delayed(const Duration(seconds: 1));
    emit(FeedbackLoaded(reviews: _mockReviews));
  }
}