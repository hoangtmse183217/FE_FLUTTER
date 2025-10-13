import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

part 'post_management_state.dart';

final List<Map<String, dynamic>> _mockPosts = [
  {
    'id': 'post1',
    'title': 'Khám phá thực đơn mùa thu mới của chúng tôi',
    'status': 'APPROVED',
    'createdAt': DateTime.now().subtract(const Duration(days: 3)),
    'restaurantName': 'The Deck Saigon',
  },
  {
    'id': 'post2',
    'title': 'Đêm nhạc Acoustic thứ Bảy hàng tuần',
    'status': 'PENDING',
    'createdAt': DateTime.now().subtract(const Duration(days: 1)),
    'restaurantName': 'The Deck Saigon',
  },
];

class PostManagementCubit extends Cubit<PostManagementState> {
  PostManagementCubit() : super(PostManagementInitial());

  Future<void> fetchMyPosts() async {
    emit(PostManagementLoading());
    // TODO: Gọi API/Firestore để lấy danh sách bài viết của Partner
    await Future.delayed(const Duration(seconds: 1));
    emit(PostManagementLoaded(posts: _mockPosts));
  }
}