import 'package:bloc/bloc.dart';
import 'package:mumiappfood/core/utils/logger.dart';
import 'package:mumiappfood/features/moods/data/repositories/mood_repository.dart';
import 'package:mumiappfood/features/post/data/models/comment_model.dart';
import 'package:mumiappfood/features/post/data/models/post_model.dart';
import 'package:mumiappfood/features/post/data/repositories/post_repository.dart';
import 'package:mumiappfood/features/post/state/post_state.dart';
import 'package:mumiappfood/features/profile/data/repositories/profile_repository.dart';
import 'package:mumiappfood/features/restaurant/data/models/restaurant_model.dart';
import 'package:mumiappfood/features/restaurant/data/repositories/restaurant_repository.dart';
import 'package:mumiappfood/features/user/data/models/user_model.dart';

class PostCubit extends Cubit<PostState> {
  final PostRepository _postRepository;
  final RestaurantRepository _restaurantRepository;
  final ProfileRepository _profileRepository;
  final MoodRepository _moodRepository; // Thêm MoodRepository

  PostCubit({
    PostRepository? postRepository,
    RestaurantRepository? restaurantRepository,
    ProfileRepository? profileRepository,
    MoodRepository? moodRepository, // Thêm vào constructor
  })  : _postRepository = postRepository ?? PostRepository(),
        _restaurantRepository = restaurantRepository ?? RestaurantRepository(),
        _profileRepository = profileRepository ?? ProfileRepository(),
        _moodRepository = moodRepository ?? MoodRepository(), // Khởi tạo
        super(PostInitial());

  Future<void> fetchPosts() async {
    if (state is PostLoading) return;
    emit(PostLoading());
    try {
      // Gọi API song song để tải posts và moods
      final results = await Future.wait([
        _getAllPosts(),
        _moodRepository.getMoods(),
      ]);

      final allPosts = results[0] as List<Post>;
      final allMoods = results[1] as List<dynamic>;

      emit(PostsLoaded(posts: allPosts, allMoods: allMoods, hasReachedMax: true));
    } catch (e) {
      emit(PostError(message: e.toString()));
    }
  }

  // Hàm helper để tải tất cả bài viết
  Future<List<Post>> _getAllPosts() async {
    List<Post> allPosts = [];
    int currentPage = 1;
    int totalPages = 1;
    do {
      final postData = await _postRepository.getPosts(page: currentPage);
      allPosts.addAll(postData['items'] as List<Post>);
      totalPages = postData['totalPages'] as int;
      currentPage++;
    } while (currentPage <= totalPages);
    return allPosts;
  }

  // --- Logic cho chi tiết bài viết (giữ nguyên) ---
  Future<void> fetchPostDetails(int postId) async {
    emit(PostLoading());
    try {
      final postFuture = _postRepository.getPostDetails(postId);
      final commentsFuture = _postRepository.getComments(postId);

      final results = await Future.wait([postFuture, commentsFuture]);
      final Post? post = results[0] as Post?;
      final List<Comment> comments = results[1] as List<Comment>;

      if (post == null) {
        emit(const PostError(message: 'Không tìm thấy bài viết.'));
        return;
      }

      final userIds = comments.map((c) => c.user?.id).where((id) => id != null).toSet().toList();

      final userFutures = userIds.map((id) {
        return _profileRepository.getUserDetails(id!)
          .then((user) => { 'id': id, 'user': user })
          .catchError((e) {
            AppLogger.error('Không thể lấy chi tiết người dùng với ID: $id', e);
            return { 'id': id, 'user': null };
          });
      }).toList();

      Future<Restaurant?> restaurantFuture = Future.value(null);
      if (post.restaurantId != null) {
        restaurantFuture = _restaurantRepository.getRestaurantDetails(post.restaurantId!).catchError((e) {
          AppLogger.error('Không thể lấy chi tiết nhà hàng với ID: ${post.restaurantId}', e);
          return null;
        });
      }
      
      final allFutures = await Future.wait([restaurantFuture, ...userFutures]);

      final Restaurant? restaurant = allFutures[0] as Restaurant?;
      final userResults = allFutures.sublist(1).cast<Map<String, dynamic>>();

      final userMap = {for (var item in userResults) item['id']: item['user'] as User?};

      final updatedComments = comments.map((comment) {
        if (comment.user?.id != null) {
          final fullUser = userMap[comment.user!.id];
          if (fullUser != null) {
            return comment.copyWith(user: fullUser);
          }
        }
        return comment;
      }).toList();

      emit(PostDetailsLoaded(
        post: post,
        comments: updatedComments,
        restaurant: restaurant,
        author: post.partnerId != null ? userMap[post.partnerId] : null,
      ));
    } catch (e) {
      emit(PostError(message: e.toString()));
    }
  }

  Future<void> addComment(int postId, String content) async {
    final currentState = state;
    if (currentState is PostDetailsLoaded) {
      emit(currentState.copyWith(isAddingComment: true, clearCommentError: true));
      try {
        final newComment = await _postRepository.addComment(postId, content);
        if (newComment != null) {
          final updatedComments = [newComment, ...currentState.comments];
          emit(currentState.copyWith(comments: updatedComments, isAddingComment: false));
        } else {
          emit(currentState.copyWith(
            isAddingComment: false,
            commentErrorMessage: 'Không thể thêm bình luận. Vui lòng thử lại.',
          ));
        }
      } catch (e) {
        emit(currentState.copyWith(
          isAddingComment: false,
          commentErrorMessage: e.toString(),
        ));
      }
    }
  }
}
