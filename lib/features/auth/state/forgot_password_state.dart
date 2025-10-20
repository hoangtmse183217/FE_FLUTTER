part of 'forgot_password_cubit.dart';

@immutable
abstract class ForgotPasswordState {}

class ForgotPasswordInitial extends ForgotPasswordState {}

class ForgotPasswordLoading extends ForgotPasswordState {}

// Trạng thái thành công, chứa thông báo để hiển thị cho người dùng
class ForgotPasswordSuccess extends ForgotPasswordState {
  final String message;
  final String resetToken;
  ForgotPasswordSuccess({required this.message, required this.resetToken});
}

class ForgotPasswordFailure extends ForgotPasswordState {
  final String message;
  ForgotPasswordFailure({required this.message});
}