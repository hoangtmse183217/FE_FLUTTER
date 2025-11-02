import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mumiappfood/features/home/data/models/discover_filter_model.dart';
import 'package:mumiappfood/features/home/data/repositories/discovery_repository.dart';
import 'package:mumiappfood/features/restaurant/data/models/restaurant_model.dart';

import '../../../core/models/sort_option.dart';

part 'discover_state.dart';

class DiscoverCubit extends Cubit<DiscoverState> {
  final DiscoveryRepository _repository;
  Timer? _debounce;

  DiscoverCubit({DiscoveryRepository? repository})
      : _repository = repository ?? DiscoveryRepository(),
        super(const DiscoverState());

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }

  Future<void> applyFiltersAndFetch({DiscoverFilter? filter}) async {
    final newFilter = filter ?? state.activeFilter;

    emit(state.copyWith(
      status: DiscoverStatus.loading,
      activeFilter: newFilter,
      clearError: true,
    ));

    try {
      final data = await _repository.searchRestaurants(
        q: newFilter.query,
        lat: newFilter.location?.latitude,
        lng: newFilter.location?.longitude,
        radiusKm: newFilter.radiusKm,
        minPrice: newFilter.minPrice,
        maxPrice: newFilter.maxPrice,
        minRating: newFilter.minRating,
        pageSize: 10, // SỬA ĐỔI: Giảm pageSize xuống 10 theo gợi ý
      );

      final restaurants = data['items'] as List<Restaurant>;
      final sortedRestaurants = _sortList(restaurants, state.activeSort, newFilter.location);

      emit(state.copyWith(
        status: DiscoverStatus.success,
        originalRestaurants: restaurants,
        displayedRestaurants: sortedRestaurants,
      ));
    } catch (e) {
      emit(state.copyWith(status: DiscoverStatus.failure, errorMessage: e.toString()));
    }
  }

  void applySort(SortOption sortOption) {
    if (state.status != DiscoverStatus.success) return;

    final sortedList = _sortList(state.originalRestaurants, sortOption, state.activeFilter.location);

    emit(state.copyWith(
      activeSort: sortOption,
      displayedRestaurants: sortedList,
    ));
  }

  void onSearchQueryChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final newFilter = state.activeFilter.copyWith(query: query);
      applyFiltersAndFetch(filter: newFilter);
    });
  }

  List<Restaurant> _sortList(List<Restaurant> originalList, SortOption sortOption, LatLng? userLocation) {
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
        if (userLocation != null) {
          sortedList.sort((a, b) {
            if (a.latitude == null || a.longitude == null) return 1;
            if (b.latitude == null || b.longitude == null) return -1;
            final distanceA = Geolocator.distanceBetween(userLocation.latitude, userLocation.longitude, a.latitude!, a.longitude!);
            final distanceB = Geolocator.distanceBetween(userLocation.latitude, userLocation.longitude, b.latitude!, b.longitude!);
            return distanceA.compareTo(distanceB);
          });
        }
        break;
      case SortOption.latest:
      default:
        break;
    }
    return sortedList;
  }
}
