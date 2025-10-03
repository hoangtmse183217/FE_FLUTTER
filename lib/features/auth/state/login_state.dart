
part of 'login_cubit.dart';
@immutable
abstract class LoginState {}

// Trạng thái ban đầu, chưa có hành động nào
class LoginInitial extends LoginState {}

// Trạng thái đang xử lý đăng nhập (hiển thị loading)
class LoginLoading extends LoginState {}

// Trạng thái đăng nhập thành công
class LoginSuccess extends LoginState {}

// Trạng thái đăng nhập thất bại, chứa thông báo lỗi
class LoginFailure extends LoginState {
  final String message;

  LoginFailure({required this.message});
}