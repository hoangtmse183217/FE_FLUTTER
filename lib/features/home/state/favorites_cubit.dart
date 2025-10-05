import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

part 'favorites_state.dart';

// Dữ liệu giả, bạn sẽ thay thế bằng cuộc gọi đến Firebase
// Giả lập bảng 'favorites' trong Firestore
final Map<String, List<String>> _mockUserFavorites = {
  'user123': ['the-deck-saigon', 'pizza-4ps'], // User này đã thích 2 nhà hàng
};

// Giả lập bảng 'restaurants'
final List<Map<String, dynamic>> _mockAllRestaurants = [
  {'id': 'the-deck-saigon', 'name': 'The Deck Saigon'},
  {'id': 'biacraft-artisan-ales', 'name': 'BiaCraft Artisan Ales'},
  {'id': 'pizza-4ps', 'name': 'Pizza 4P\'s'},
];

class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit() : super(FavoritesInitial());

  // Lấy ID của user hiện tại từ Firebase Auth
  final String _userId = 'user123'; // Thay thế bằng FirebaseAuth.instance.currentUser.uid

  // Tải danh sách nhà hàng yêu thích
  Future<void> fetchFavorites() async {
    emit(FavoritesLoading());
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      // 1. Lấy danh sách ID yêu thích của user
      final favoriteIds = _mockUserFavorites[_userId] ?? [];

      // 2. Lấy thông tin chi tiết của các nhà hàng đó
      final favoriteRestaurants = _mockAllRestaurants
          .where((restaurant) => favoriteIds.contains(restaurant['id']))
          .toList();

      emit(FavoritesLoaded(
        favoriteIds: favoriteIds.toSet(),
        favoriteRestaurants: favoriteRestaurants,
      ));
    } catch (e) {
      emit(FavoritesError(message: 'Không thể tải danh sách yêu thích.'));
    }
  }

  // Thêm/Xóa một nhà hàng khỏi danh sách yêu thích
  void toggleFavorite(String restaurantId) {
    if (state is FavoritesLoaded) {
      final currentState = state as FavoritesLoaded;
      final currentIds = Set<String>.from(currentState.favoriteIds);
      final isCurrentlyFavorite = currentIds.contains(restaurantId);

      // Cập nhật UI ngay lập tức để có trải nghiệm mượt mà
      if (isCurrentlyFavorite) {
        currentIds.remove(restaurantId);
      } else {
        currentIds.add(restaurantId);
      }

      // Tìm và cập nhật danh sách nhà hàng chi tiết
      final updatedRestaurants = _mockAllRestaurants
          .where((restaurant) => currentIds.contains(restaurant['id']))
          .toList();

      emit(currentState.copyWith(
        favoriteIds: currentIds,
        favoriteRestaurants: updatedRestaurants,
      ));

      // TODO: Sau khi cập nhật UI, gọi API để lưu thay đổi vào Firebase
      // if (isCurrentlyFavorite) {
      //   // Xóa khỏi bảng 'favorites'
      // } else {
      //   // Thêm vào bảng 'favorites'
      // }
    }
  }


}