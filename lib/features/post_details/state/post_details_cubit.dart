import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'post_details_state.dart';

// Dữ liệu giả cho một bài viết
final Map<String, dynamic> _mockPostData = {
  'id': 'post1',
  'title': 'Khám phá thực đơn mùa thu mới của chúng tôi',
  'content': 'Mùa thu đã về, và cùng với đó là những hương vị mới lạ tại The Deck Saigon. Chúng tôi tự hào giới thiệu thực đơn đặc biệt, lấy cảm hứng từ những nguyên liệu tươi ngon nhất của mùa thu...\n\n(Đây là nội dung chi tiết của bài viết, có thể rất dài và chứa các định dạng văn bản).',
  'coverImageUrl': 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=500',
  'restaurantName': 'The Deck Saigon',
  'restaurantId': 'the-deck-saigon',
  'createdAt': DateTime.now().subtract(const Duration(days: 3)),
};

class PostDetailsCubit extends Cubit<PostDetailsState> {
  PostDetailsCubit() : super(PostDetailsInitial());

  Future<void> fetchPostDetails(String postId) async {
    emit(PostDetailsLoading());
    // TODO: Thay thế bằng logic gọi API/Firestore để lấy dữ liệu bài viết
    await Future.delayed(const Duration(seconds: 1));
    emit(PostDetailsLoaded(postData: _mockPostData));
  }
}