part of 'owner_register_cubit.dart';

@immutable
abstract class OwnerRegisterState {}

class OwnerRegisterInitial extends OwnerRegisterState {}
class OwnerRegisterLoading extends OwnerRegisterState {}
class OwnerRegisterSuccess extends OwnerRegisterState {}
class OwnerRegisterFailure extends OwnerRegisterState {
  final String message;
  OwnerRegisterFailure({required this.message});
}