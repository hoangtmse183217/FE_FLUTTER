part of 'post_management_cubit.dart';

@immutable
abstract class PostManagementState {}

class PostManagementInitial extends PostManagementState {}
class PostManagementLoading extends PostManagementState {}
class PostManagementError extends PostManagementState {
  final String message;
  PostManagementError({required this.message});
}

class PostManagementLoaded extends PostManagementState {
  // Dữ liệu giả, sẽ thay thế bằng model Post
  final List<Map<String, dynamic>> posts;
  PostManagementLoaded({required this.posts});
}