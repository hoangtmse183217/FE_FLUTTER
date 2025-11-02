import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mumiappfood/features/restaurant/data/models/restaurant_model.dart';
import 'package:mumiappfood/features/restaurant/data/repositories/restaurant_repository.dart';
import 'package:mumiappfood/features/restaurant/state/restaurant_state.dart';

class RestaurantCubit extends Cubit<RestaurantState> {
  final RestaurantRepository _repository;

  RestaurantCubit({RestaurantRepository? repository})
      : _repository = repository ?? RestaurantRepository(),
        super(RestaurantInitial());

  void _emitPaginatedSuccess(Map<String, dynamic> data) {
    final restaurants = data['items'] as List<Restaurant>;
    final page = data['page'] as int;
    final totalPages = data['totalPages'] as int;

    emit(RestaurantsLoaded(
      restaurants: restaurants,
      currentPage: page,
      totalPages: totalPages,
      hasReachedMax: page >= totalPages,
    ));
  }

  Future<void> fetchRestaurants() async {
    emit(RestaurantLoading());
    try {
      final data = await _repository.getRestaurants(page: 1);
      _emitPaginatedSuccess(data);
    } catch (e) {
      emit(RestaurantError(e.toString()));
    }
  }

  Future<void> fetchNextPage() async {
    if (state is! RestaurantsLoaded) return;
    final currentState = state as RestaurantsLoaded;
    if (currentState.hasReachedMax || currentState.isLoadingNextPage) return;

    emit(currentState.copyWith(isLoadingNextPage: true));

    try {
      final nextPage = currentState.currentPage + 1;
      final data = await _repository.getRestaurants(page: nextPage);
      final newRestaurants = data['items'] as List<Restaurant>;
      final totalPages = data['totalPages'] as int;

      emit(currentState.copyWith(
        restaurants: currentState.restaurants + newRestaurants,
        currentPage: nextPage,
        totalPages: totalPages,
        hasReachedMax: nextPage >= totalPages,
        isLoadingNextPage: false,
      ));
    } catch (e) {
      emit(currentState.copyWith(nextPageError: e.toString(), isLoadingNextPage: false));
    }
  }

  Future<void> fetchRestaurantDetails(String restaurantId) async {
    emit(RestaurantLoading());
    try {
      final id = int.tryParse(restaurantId);
      if (id == null) {
        throw const FormatException('ID của nhà hàng không hợp lệ.');
      }
      final restaurant = await _repository.getRestaurantDetails(id);
      emit(RestaurantDetailsLoaded(restaurant));
    } catch (e) {
      emit(RestaurantError(e.toString()));
    }
  }

  Future<void> fetchNearbyRestaurants({required double lat, required double lng}) async {
    emit(RestaurantLoading());
    try {
      final List<Restaurant> restaurants = await _repository.getNearbyRestaurants(lat: lat, lng: lng);
      emit(RestaurantsLoaded(
        restaurants: restaurants,
        currentPage: 1,
        totalPages: 1, 
        hasReachedMax: true,
      ));
    } catch (e) {
      emit(RestaurantError(e.toString()));
    }
  }
}
