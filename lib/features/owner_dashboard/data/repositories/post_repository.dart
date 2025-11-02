import 'package:image_picker/image_picker.dart';
import '../providers/post_api_provider.dart';

class PostRepository {
  final _apiProvider = PostApiProvider();

  Future<Map<String, dynamic>> getMyPosts({int page = 1, int pageSize = 10}) {
    return _apiProvider.fetchMyPosts(page: page, pageSize: pageSize);
  }

  Future<Map<String, dynamic>> addPost(Map<String, dynamic> data) {
    return _apiProvider.addPost(data);
  }

  Future<void> updatePost(String postId, Map<String, dynamic> data) {
    return _apiProvider.updatePost(postId, data);
  }

  Future<Map<String, dynamic>> getPostDetails(String postId) {
    return _apiProvider.getPostDetails(postId);
  }

  Future<void> deletePost(String postId) {
    return _apiProvider.deletePost(postId);
  }

  Future<String> uploadPostImage(String postId, XFile imageFile) {
    return _apiProvider.uploadPostImage(postId, imageFile);
  }

  Future<void> addMoodToPost(String postId, int moodId) {
    return _apiProvider.addMoodToPost(postId, moodId);
  }

  Future<void> removeMoodFromPost(String postId, int moodId) {
    return _apiProvider.removeMoodFromPost(postId, moodId);
  }
}
