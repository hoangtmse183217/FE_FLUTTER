part of 'home_cubit.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoaded extends HomeState {
  final User user; // Đối tượng User từ Firebase Auth
  HomeLoaded({required this.user});
}