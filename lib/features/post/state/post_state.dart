import 'package:equatable/equatable.dart';
import 'package:mumiappfood/features/post/data/models/comment_model.dart';
import 'package:mumiappfood/features/post/data/models/post_model.dart';
import 'package:mumiappfood/features/restaurant/data/models/restaurant_model.dart';
import 'package:mumiappfood/features/user/data/models/user_model.dart';

abstract class PostState extends Equatable {
  const PostState();

  @override
  List<Object?> get props => [];
}

class PostInitial extends PostState {}

class PostLoading extends PostState {}

class PostError extends PostState {
  final String message;
  const PostError({required this.message});

  @override
  List<Object> get props => [message];
}

// State cho màn hình danh sách bài viết (Post Feed)
class PostsLoaded extends PostState {
  final List<Post> posts;
  final List<dynamic> allMoods; // SỬA: Thêm danh sách moods
  final bool hasReachedMax;

  const PostsLoaded({
    this.posts = const [], 
    this.allMoods = const [], // SỬA: Thêm vào constructor
    this.hasReachedMax = false
  });

  PostsLoaded copyWith({
    List<Post>? posts,
    List<dynamic>? allMoods,
    bool? hasReachedMax,
  }) {
    return PostsLoaded(
      posts: posts ?? this.posts,
      allMoods: allMoods ?? this.allMoods,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [posts, allMoods, hasReachedMax];
}


// State cho màn hình chi tiết bài viết
class PostDetailsLoaded extends PostState {
  final Post post;
  final List<Comment> comments;
  final bool isAddingComment;
  final String? commentErrorMessage;
  final Restaurant? restaurant;
  final User? author;

  const PostDetailsLoaded({
    required this.post,
    required this.comments,
    this.isAddingComment = false,
    this.commentErrorMessage,
    this.restaurant,
    this.author,
  });

  PostDetailsLoaded copyWith({
    Post? post,
    List<Comment>? comments,
    bool? isAddingComment,
    String? commentErrorMessage,
    bool clearCommentError = false,
    Restaurant? restaurant,
    User? author,
  }) {
    return PostDetailsLoaded(
      post: post ?? this.post,
      comments: comments ?? this.comments,
      isAddingComment: isAddingComment ?? this.isAddingComment,
      commentErrorMessage: clearCommentError ? null : commentErrorMessage ?? this.commentErrorMessage,
      restaurant: restaurant ?? this.restaurant,
      author: author ?? this.author,
    );
  }

  @override
  List<Object?> get props => [post, comments, isAddingComment, commentErrorMessage, restaurant, author];
}
