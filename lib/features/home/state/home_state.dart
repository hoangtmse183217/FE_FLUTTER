part of 'home_cubit.dart';

@immutable
abstract class HomeState {}

// Trạng thái ban đầu, không có gì đặc biệt
class HomeInitial extends HomeState {}

// Trạng thái được phát ra sau khi đăng xuất thành công
// Điều này hữu ích cho BlocListener nếu bạn muốn thực hiện hành động nào đó
class HomeLogoutSuccess extends HomeState {}

// Trạng thái khi có lỗi trong quá trình xử lý của HomeCubit (nếu có)
class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}