part of 'post_management_cubit.dart';

@immutable
abstract class PostManagementState {
  // Đưa danh sách bài viết lên state cha để các state con có thể truy cập
  final List<dynamic> posts;
  const PostManagementState({this.posts = const []});
}

class PostManagementInitial extends PostManagementState {}

class PostManagementLoading extends PostManagementState {
  // State loading vẫn có thể giữ lại danh sách bài viết cũ
  const PostManagementLoading({super.posts});
}

class PostManagementError extends PostManagementState {
  final String message;
  final bool isActionError; // Phân biệt lỗi tải dữ liệu và lỗi hành động

  const PostManagementError({
    required this.message,
    this.isActionError = false,
    super.posts, // Nhận danh sách bài viết cũ khi có lỗi
  });
}

class PostDeleteSuccess extends PostManagementState {
  final String deletedPostTitle;

  // State này không cần thay đổi vì nó sẽ được thay thế ngay bằng state loaded/loading
  const PostDeleteSuccess({required this.deletedPostTitle, super.posts});
}

class PostManagementLoaded extends PostManagementState {
  final int currentPage;
  final int totalPages;

  const PostManagementLoaded({
    required super.posts,
    required this.currentPage,
    required this.totalPages,
  });

  PostManagementLoaded copyWith({
    List<dynamic>? posts,
    int? currentPage,
    int? totalPages,
  }) {
    return PostManagementLoaded(
      posts: posts ?? this.posts,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
    );
  }
}
