import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mumiappfood/features/moods/data/repositories/mood_repository.dart';
import 'package:mumiappfood/features/owner_dashboard/data/repositories/post_repository.dart';
import 'package:mumiappfood/features/owner_dashboard/data/repositories/restaurant_repository.dart';

part 'add_edit_post_state.dart';

class AddEditPostCubit extends Cubit<AddEditPostState> {
  final PostRepository _postRepository = PostRepository();
  final RestaurantRepository _restaurantRepository = RestaurantRepository();
  final MoodRepository _moodRepository = MoodRepository();
  final ImagePicker _picker = ImagePicker();

  AddEditPostCubit() : super(AddEditPostInitial());

  Future<void> loadDataForCreate() async {
    emit(AddEditPostLoadingData());
    try {
      final results = await Future.wait([
        _restaurantRepository.getMyRestaurants(),
        _moodRepository.getMoods(),
      ]);

      final allRestaurants = results[0] as List<dynamic>;
      final allMoods = results[1] as List<dynamic>;

      final approvedRestaurants = allRestaurants
          .where((r) => (r['status'] as String?)?.toLowerCase() == 'approved')
          .toList();

      emit(AddEditPostReady(
        approvedRestaurants: approvedRestaurants.cast<Map<String, dynamic>>(),
        allMoods: allMoods.cast<Map<String, dynamic>>(),
      ));
    } catch (e) {
      emit(AddEditPostError('Không thể tải dữ liệu tạo bài viết: ${e.toString()}'));
    }
  }

  Future<void> loadPostForEdit(String postId) async {
    emit(AddEditPostLoadingData());
    try {
      final results = await Future.wait([
        _restaurantRepository.getMyRestaurants(),
        _postRepository.getPostDetails(postId),
        _moodRepository.getMoods(),
      ]);

      final allRestaurants = results[0] as List<dynamic>;
      final postData = results[1] as Map<String, dynamic>;
      final allMoods = results[2] as List<dynamic>;

      final approvedRestaurants = allRestaurants
          .where((r) => (r['status'] as String?)?.toLowerCase() == 'approved' || r['id'] == postData['restaurantId'])
          .toList();

      emit(AddEditPostReady(
        approvedRestaurants: approvedRestaurants.cast<Map<String, dynamic>>(),
        allMoods: allMoods.cast<Map<String, dynamic>>(),
        initialPostData: postData,
      ));
    } catch (e) {
      emit(AddEditPostError('Không thể tải dữ liệu để sửa: ${e.toString()}'));
    }
  }

  Future<void> pickImage() async {
    if (state is! AddEditPostReady) return;
    final currentState = state as AddEditPostReady;

    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      emit(currentState.copyWith(newImageFile: image));
    }
  }

  Future<void> submitPost({
    String? postId,
    required String title,
    required String content,
    required int restaurantId,
  }) async {
    if (state is! AddEditPostReady) return;
    final currentState = state as AddEditPostReady;
    emit(currentState.copyWith(isSaving: true));

    try {
      final data = {
        'title': title,
        'content': content,
        'restaurantId': restaurantId,
      };

      if (postId != null) { // Chế độ Sửa
        await _postRepository.updatePost(postId, data);
        if (currentState.newImageFile != null) {
          await _postRepository.uploadPostImage(postId, currentState.newImageFile!);
        }
      } else { // Chế độ Tạo mới
        final newPost = await _postRepository.addPost(data);
        final newPostId = newPost['id'].toString();
        if (currentState.newImageFile != null) {
          await _postRepository.uploadPostImage(newPostId, currentState.newImageFile!);
        }
      }

      emit(AddEditPostSuccess());
    } catch (e) {
      emit(AddEditPostError(e.toString()));
      emit(currentState.copyWith(isSaving: false));
    }
  }

  Future<void> toggleMood(String postId, Map<String, dynamic> mood) async {
    if (state is! AddEditPostReady) return;
    final currentState = state as AddEditPostReady;

    final currentMoods = List<Map<String, dynamic>>.from(currentState.initialPostData?['moods'] ?? []);
    final isSelected = currentMoods.any((m) => m['id'] == mood['id']);

    try {
      // 1. Gọi API để thêm hoặc xóa
      if (isSelected) {
        await _postRepository.removeMoodFromPost(postId, mood['id']);
      } else {
        await _postRepository.addMoodToPost(postId, mood['id']);
      }

      // 2. Sau khi thành công, tải lại toàn bộ dữ liệu bài viết để đảm bảo tính nhất quán
      final freshPostData = await _postRepository.getPostDetails(postId);

      // 3. Cập nhật state với dữ liệu mới nhất từ server
      emit(currentState.copyWith(initialPostData: freshPostData));

    } catch (e) {
      emit(AddEditPostError('Lỗi cập nhật chủ đề: ${e.toString()}'));
      // Nếu có lỗi, emit lại state cũ để xóa thông báo lỗi và hoàn tác trạng thái loading (nếu có)
      emit(currentState);
    }
  }
}
