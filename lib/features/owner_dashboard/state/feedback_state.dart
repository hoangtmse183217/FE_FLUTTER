part of 'feedback_cubit.dart';

@immutable
abstract class FeedbackState {}

class FeedbackInitial extends FeedbackState {}
class FeedbackLoading extends FeedbackState {}
class FeedbackError extends FeedbackState {
  final String message;
  FeedbackError({required this.message});
}

class FeedbackLoaded extends FeedbackState {
  // Dữ liệu giả, bạn sẽ thay thế bằng model Review thật
  final List<Map<String, dynamic>> reviews;
  FeedbackLoaded({required this.reviews});
}