import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

part 'discover_state.dart';

// Đảm bảo biến này có kiểu dữ liệu tường minh
final List<Map<String, dynamic>> _allRestaurants = [
  {'id': 'the-deck-saigon', 'name': 'The Deck Saigon', 'moods': ['Lãng mạn', 'Sang trọng', 'Thư giãn']},
  {'id': 'biacraft-artisan-ales', 'name': 'BiaCraft Artisan Ales', 'moods': ['Sôi động', 'Bạn bè']},
  {'id': 'pizza-4ps', 'name': 'Pizza 4P\'s', 'moods': ['Gia đình', 'Lãng mạn']},
  {'id': 'cuc-gach-quan', 'name': 'Cuc Gach Quan', 'moods': ['Gia đình', 'Thư giãn']},
  {'id': 'anan-saigon', 'name': 'Anan Saigon', 'moods': ['Sôi động', 'Sang trọng']}
];

final List<String> _allMoods = ['Lãng mạn', 'Sôi động', 'Thư giãn', 'Sang trọng', 'Gia đình', 'Nhanh gọn', 'Bạn bè'];

class DiscoverCubit extends Cubit<DiscoverState> {
  DiscoverCubit() : super(DiscoverInitial());

  Future<void> fetchInitialData() async {
    emit(DiscoverLoading());
    await Future.delayed(const Duration(milliseconds: 100));
    emit(DiscoverLoaded(
      allMoods: _allMoods,
      selectedMoods: {},
      restaurants: _allRestaurants,
    ));
  }

  void filterByMood(String mood) async {
    if (state is DiscoverLoaded) {
      final currentState = state as DiscoverLoaded;
      final currentSelectedMoods = Set<String>.from(currentState.selectedMoods);

      if (currentSelectedMoods.contains(mood)) {
        currentSelectedMoods.remove(mood);
      } else {
        currentSelectedMoods.add(mood);
      }

      emit(currentState.copyWith(selectedMoods: currentSelectedMoods, isLoading: true));
      await Future.delayed(const Duration(milliseconds: 300));

      // Đảm bảo biến này cũng có kiểu dữ liệu tường minh
      List<Map<String, dynamic>> filteredRestaurants;
      if (currentSelectedMoods.isEmpty) {
        filteredRestaurants = _allRestaurants;
      } else {
        filteredRestaurants = _allRestaurants.where((restaurant) {
          final restaurantMoods = Set<String>.from(restaurant['moods']);
          return currentSelectedMoods.every((selectedMood) => restaurantMoods.contains(selectedMood));
        }).toList();
      }

      emit(currentState.copyWith(
        selectedMoods: currentSelectedMoods,
        restaurants: filteredRestaurants,
        isLoading: false,
      ));
    }
  }

  void applyFilters({
    required Set<String> priceRanges,
    required double rating,
  }) async {
    if (state is DiscoverLoaded) {
      final currentState = state as DiscoverLoaded;

      emit(currentState.copyWith(
        selectedPriceRanges: priceRanges,
        minRating: rating,
        isLoading: true,
      ));

      await Future.delayed(const Duration(milliseconds: 300));

      List<Map<String, dynamic>> filteredList = _allRestaurants;

      // Áp dụng các bộ lọc
      // TODO: Thay thế logic lọc này bằng truy vấn Firestore thật
      if (priceRanges.isNotEmpty) {
        // Giả sử bạn có trường 'priceRange' trong dữ liệu
        // filteredList = filteredList.where((r) => priceRanges.contains(r['priceRange'])).toList();
      }
      if (rating > 0) {
        // Giả sử bạn có trường 'rating' trong dữ liệu
        // filteredList = filteredList.where((r) => r['rating'] >= rating).toList();
      }

      emit(currentState.copyWith(
        restaurants: filteredList,
        isLoading: false,
      ));
    }
  }
}