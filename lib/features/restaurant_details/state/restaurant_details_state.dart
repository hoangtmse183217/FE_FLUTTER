part of 'restaurant_details_cubit.dart';
@immutable
abstract class RestaurantDetailsState {}
class RestaurantDetailsInitial extends RestaurantDetailsState {}
class RestaurantDetailsLoading extends RestaurantDetailsState {}
class RestaurantDetailsLoaded extends RestaurantDetailsState {
// Dữ liệu giả, bạn sẽ thay thế bằng model Restaurant thật
  final Map<String, dynamic> restaurantData;
  RestaurantDetailsLoaded({required this.restaurantData});
}
class RestaurantDetailsError extends RestaurantDetailsState {
  final String message;
  RestaurantDetailsError({required this.message});
}