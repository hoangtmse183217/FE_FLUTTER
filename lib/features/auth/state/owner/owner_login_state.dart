part of 'owner_login_cubit.dart';

@immutable
abstract class OwnerLoginState {}

class OwnerLoginInitial extends OwnerLoginState {}
class OwnerLoginLoading extends OwnerLoginState {}
class OwnerLoginSuccess extends OwnerLoginState {}
class OwnerLoginFailure extends OwnerLoginState {
  final String message;
  OwnerLoginFailure({required this.message});
}