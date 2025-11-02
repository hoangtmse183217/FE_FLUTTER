import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:mumiappfood/core/models/sort_option.dart';
import 'package:mumiappfood/features/favorites/data/repositories/favorites_repository.dart';
import 'package:mumiappfood/features/restaurant/data/models/restaurant_model.dart';

// GỘP STATE VÀO CHUNG FILE ĐỂ GIẢI QUYẾT LỖI
part 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final FavoritesRepository _repository;

  FavoritesCubit({FavoritesRepository? repository})
      : _repository = repository ?? FavoritesRepository(),
        super(const FavoritesState());

  Future<void> fetchFavorites() async {
    if (state.status == FavoritesStatus.loading) return;
    emit(state.copyWith(status: FavoritesStatus.loading, clearError: true));
    try {
      final myFavorites = await _repository.getMyFavorites();
      final favoriteRestaurants = myFavorites.map((fav) => fav.restaurant).toList();
      final favoriteIds = favoriteRestaurants.map((res) => res.id).toSet();

      final sortedRestaurants = _sortList(favoriteRestaurants, state.activeSort);

      emit(state.copyWith(
        status: FavoritesStatus.success,
        originalFavorites: favoriteRestaurants,
        displayedFavorites: sortedRestaurants,
        favoriteIds: favoriteIds,
      ));
    } catch (e) {
      emit(state.copyWith(status: FavoritesStatus.failure, errorMessage: e.toString()));
    }
  }

  void applySort(SortOption sortOption) {
    if (state.status != FavoritesStatus.success) return;

    final sortedList = _sortList(state.originalFavorites, sortOption);

    emit(state.copyWith(
      activeSort: sortOption,
      displayedFavorites: sortedList,
    ));
  }

  Future<void> toggleFavorite(int restaurantId, {Restaurant? restaurant}) async {
    final originalState = state;
    final isCurrentlyFavorite = originalState.favoriteIds.contains(restaurantId);

    final newIds = Set<int>.from(originalState.favoriteIds);
    final newOriginals = List<Restaurant>.from(originalState.originalFavorites);

    if (isCurrentlyFavorite) {
      newIds.remove(restaurantId);
      newOriginals.removeWhere((r) => r.id == restaurantId);
    } else {
      newIds.add(restaurantId);
      if (restaurant != null) {
        newOriginals.insert(0, restaurant);
      }
    }

    final newDisplayed = _sortList(newOriginals, originalState.activeSort);

    emit(state.copyWith(
      favoriteIds: newIds,
      originalFavorites: newOriginals,
      displayedFavorites: newDisplayed,
    ));

    try {
      if (isCurrentlyFavorite) {
        await _repository.removeFavorite(restaurantId);
      } else {
        await _repository.addFavorite(restaurantId);
      }
      if (!isCurrentlyFavorite && restaurant == null) {
        await fetchFavorites();
      }
    } catch (e) {
      emit(originalState.copyWith(
        status: FavoritesStatus.failure,
        errorMessage: 'Lỗi cập nhật Yêu thích',
      ));
      await Future.delayed(const Duration(seconds: 2));
      emit(state.copyWith(clearError: true));
    }
  }

  List<Restaurant> _sortList(List<Restaurant> originalList, SortOption sortOption) {
    List<Restaurant> sortedList = List.from(originalList);

    switch (sortOption) {
      case SortOption.nameAZ:
        sortedList.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        break;
      case SortOption.nameZA:
        sortedList.sort((a, b) => b.name.toLowerCase().compareTo(a.name.toLowerCase()));
        break;
      case SortOption.priceAsc:
        sortedList.sort((a, b) => (a.avgPrice ?? 0).compareTo(b.avgPrice ?? 0));
        break;
      case SortOption.priceDesc:
        sortedList.sort((a, b) => (b.avgPrice ?? 0).compareTo(a.avgPrice ?? 0));
        break;
      case SortOption.ratingDesc:
        sortedList.sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));
        break;
      case SortOption.distance:
      case SortOption.latest:
      default:
        break;
    }
    return sortedList;
  }
}
