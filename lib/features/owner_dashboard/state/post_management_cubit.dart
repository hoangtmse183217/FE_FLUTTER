import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:mumiappfood/features/owner_dashboard/data/repositories/post_repository.dart';

part 'post_management_state.dart';

class PostManagementCubit extends Cubit<PostManagementState> {
  final PostRepository _repository = PostRepository();

  PostManagementCubit() : super(PostManagementInitial());

  Future<void> fetchMyPosts({int page = 1}) async {
    // Giữ lại danh sách bài viết cũ khi tải lại
    final currentPosts = state.posts;
    emit(PostManagementLoading(posts: currentPosts));

    try {
      final postData = await _repository.getMyPosts(page: page);
      emit(PostManagementLoaded(
        posts: postData['items'] as List<dynamic>,
        currentPage: postData['page'] as int,
        totalPages: postData['totalPages'] as int,
      ));
    } catch (e) {
      // isActionError là false vì đây là lỗi tải dữ liệu
      emit(PostManagementError(message: e.toString(), posts: currentPosts, isActionError: false));
    }
  }

  Future<void> deletePost(int postId, String postTitle) async {
    final currentPosts = state.posts;
    try {
      await _repository.deletePost(postId.toString());
      // Tạm thời xóa bài viết khỏi UI để người dùng thấy ngay lập tức
      final updatedPosts = currentPosts.where((p) => p['id'] != postId).toList();

      // Thông báo thành công và cập nhật UI
      emit(PostDeleteSuccess(deletedPostTitle: postTitle, posts: updatedPosts));

      // Có thể không cần fetch lại ngay, hoặc có thể fetch sau 1 khoảng thời gian
      // Để đơn giản, ta chỉ cập nhật state
      emit(PostManagementLoaded(
        posts: updatedPosts,
        currentPage: state is PostManagementLoaded ? (state as PostManagementLoaded).currentPage : 1,
        totalPages: state is PostManagementLoaded ? (state as PostManagementLoaded).totalPages : 1,
      ));

    } catch (e) {
      // isActionError là true vì đây là lỗi từ một hành động cụ thể
      emit(PostManagementError(message: e.toString(), posts: currentPosts, isActionError: true));
    }
  }
}
