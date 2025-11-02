import 'package:mumiappfood/features/post/data/models/comment_model.dart';
import 'package:mumiappfood/features/post/data/models/post_model.dart';
import 'package:mumiappfood/features/post/data/providers/post_api_provider.dart';

class PostRepository {
  final _apiProvider = PostApiProvider();

  Future<Map<String, dynamic>> getPosts({required int page, int pageSize = 10}) async {
    try {
      final Map<String, dynamic>? rawData = await _apiProvider.getPosts(page: page, pageSize: pageSize);

      if (rawData == null || rawData['items'] == null) {
        return {'items': <Post>[], 'page': page, 'totalPages': 0};
      }

      final List<dynamic> items = rawData['items'] as List<dynamic>;
      
      // SỬA LỖI: Lọc ra các phần tử null từ danh sách trước khi parse
      final List<Post> posts = items
          .where((data) => data != null) // Chỉ giữ lại những phần tử không phải là null
          .map((data) => Post.fromMap(data as Map<String, dynamic>))
          .toList();
      
      return {
        'items': posts,
        'page': rawData['page'] ?? page,
        'totalPages': rawData['totalPages'] ?? 0,
      };
    } catch (e) {
      // Ném lại lỗi gốc để cubit có thể log chi tiết hơn
      throw Exception('Failed to load posts feed: $e');
    }
  }

  Future<Post?> getPostDetails(int postId) async {
    try {
      final Map<String, dynamic>? postData = await _apiProvider.getPostDetails(postId);
      if (postData == null) {
        return null;
      }
      return Post.fromMap(postData);
    } catch (e) {
      throw Exception('Failed to load post details: $e');
    }
  }

  Future<List<Comment>> getComments(int postId) async {
    try {
      final List<dynamic> commentData = await _apiProvider.getComments(postId);
      // SỬA LỖI: Lọc null để phòng thủ
      return commentData
          .where((data) => data != null)
          .map((data) => Comment.fromMap(data as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to load comments: $e');
    }
  }
  
  Future<Comment?> addComment(int postId, String content) async {
    try {
      final Map<String, dynamic>? newCommentData = await _apiProvider.addComment(postId, content);
      if (newCommentData == null) {
        return null;
      }
      return Comment.fromMap(newCommentData);
    } catch (e) {
      throw Exception('Failed to add comment: $e');
    }
  }

  Future<Map<String, dynamic>> getPostsByRestaurant({
    required int restaurantId,
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final Map<String, dynamic>? rawData = await _apiProvider.getPostsByRestaurant(
        restaurantId: restaurantId,
        page: page,
        pageSize: pageSize,
      );

      if (rawData == null || rawData['items'] == null) {
        return {'items': <Post>[], 'page': page, 'totalPages': 0};
      }
      
      final List<dynamic> items = rawData['items'] as List<dynamic>;

      // SỬA LỖI: Lọc ra các phần tử null từ danh sách trước khi parse
      final List<Post> posts = items
          .where((data) => data != null) // Chỉ giữ lại những phần tử không phải là null
          .map((data) => Post.fromMap(data as Map<String, dynamic>))
          .toList();

      return {
        'items': posts,
        'page': rawData['page'] ?? page,
        'totalPages': rawData['totalPages'] ?? 0,
      };
    } catch (e) {
      throw Exception('Failed to load posts for restaurant: $e');
    }
  }
}
