part of 'post_details_cubit.dart';

@immutable
abstract class PostDetailsState {}

class PostDetailsInitial extends PostDetailsState {}
class PostDetailsLoading extends PostDetailsState {}
class PostDetailsError extends PostDetailsState {
  final String message;
  PostDetailsError({required this.message});
}
class PostDetailsLoaded extends PostDetailsState {
  // Dữ liệu giả, bạn sẽ thay thế bằng model Post
  final Map<String, dynamic> postData;
  PostDetailsLoaded({required this.postData});
}