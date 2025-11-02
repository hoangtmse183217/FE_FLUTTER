import 'package:equatable/equatable.dart';
import 'package:mumiappfood/features/restaurant/data/models/restaurant_model.dart';

abstract class RestaurantState extends Equatable {
  const RestaurantState();

  @override
  List<Object?> get props => [];
}

class RestaurantInitial extends RestaurantState {}

class RestaurantLoading extends RestaurantState {}

class RestaurantsLoaded extends RestaurantState {
  final List<Restaurant> restaurants;
  final int currentPage;
  final int totalPages;
  final bool hasReachedMax;
  final String? nextPageError;
  final bool isLoadingNextPage;

  const RestaurantsLoaded({
    required this.restaurants,
    required this.currentPage,
    required this.totalPages,
    this.hasReachedMax = false,
    this.nextPageError,
    this.isLoadingNextPage = false,
  });

  RestaurantsLoaded copyWith({
    List<Restaurant>? restaurants,
    int? currentPage,
    int? totalPages,
    bool? hasReachedMax,
    String? nextPageError,
    bool? isLoadingNextPage,
    bool clearNextPageError = false,
  }) {
    return RestaurantsLoaded(
      restaurants: restaurants ?? this.restaurants,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      nextPageError: clearNextPageError ? null : nextPageError ?? this.nextPageError,
      isLoadingNextPage: isLoadingNextPage ?? this.isLoadingNextPage,
    );
  }

  @override
  List<Object?> get props => [restaurants, currentPage, totalPages, hasReachedMax, nextPageError, isLoadingNextPage];
}

class RestaurantDetailsLoaded extends RestaurantState {
  final Restaurant restaurant;

  const RestaurantDetailsLoaded(this.restaurant);

  @override
  List<Object?> get props => [restaurant];
}

class RestaurantError extends RestaurantState {
  final String message;

  const RestaurantError(this.message);

  @override
  List<Object?> get props => [message];
}
