part of 'favorites_cubit.dart';

@immutable
abstract class FavoritesState {}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  // Set chứa ID của các nhà hàng yêu thích để kiểm tra nhanh
  final Set<String> favoriteIds;
  // List chứa dữ liệu chi tiết của các nhà hàng yêu thích
  final List<Map<String, dynamic>> favoriteRestaurants;

  FavoritesLoaded({
    required this.favoriteIds,
    required this.favoriteRestaurants,
  });

  FavoritesLoaded copyWith({
    Set<String>? favoriteIds,
    List<Map<String, dynamic>>? favoriteRestaurants,
  }) {
    return FavoritesLoaded(
      favoriteIds: favoriteIds ?? this.favoriteIds,
      favoriteRestaurants: favoriteRestaurants ?? this.favoriteRestaurants,
    );
  }
}

class FavoritesError extends FavoritesState {
  final String message;
  FavoritesError({required this.message});
}