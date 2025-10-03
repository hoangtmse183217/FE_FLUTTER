part of 'splash_cubit.dart';

@immutable
abstract class SplashState {}

// Trạng thái ban đầu, khi màn hình vừa được tải
class SplashInitial extends SplashState {}

// Trạng thái khi đã xử lý xong và sẵn sàng điều hướng
class SplashLoaded extends SplashState {
  final String destinationRoute; // Route sẽ điều hướng tới ('/' hoặc '/login')

  SplashLoaded({required this.destinationRoute});
}