part of 'favorites_cubit.dart';

// Enum để quản lý trạng thái tải dữ liệu
enum FavoritesStatus { initial, loading, success, failure }

@immutable
class FavoritesState extends Equatable {
  final FavoritesStatus status;
  final List<Restaurant> originalFavorites; // Danh sách gốc từ API
  final List<Restaurant> displayedFavorites; // Danh sách đã sắp xếp để hiển thị
  final Set<int> favoriteIds; // Vẫn giữ lại để check nhanh
  final SortOption activeSort;
  final String? errorMessage;

  const FavoritesState({
    this.status = FavoritesStatus.initial,
    this.originalFavorites = const [],
    this.displayedFavorites = const [],
    this.favoriteIds = const {},
    this.activeSort = SortOption.latest,
    this.errorMessage,
  });

  FavoritesState copyWith({
    FavoritesStatus? status,
    List<Restaurant>? originalFavorites,
    List<Restaurant>? displayedFavorites,
    Set<int>? favoriteIds,
    SortOption? activeSort,
    String? errorMessage,
    bool clearError = false,
  }) {
    return FavoritesState(
      status: status ?? this.status,
      originalFavorites: originalFavorites ?? this.originalFavorites,
      displayedFavorites: displayedFavorites ?? this.displayedFavorites,
      favoriteIds: favoriteIds ?? this.favoriteIds,
      activeSort: activeSort ?? this.activeSort,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        originalFavorites,
        displayedFavorites,
        favoriteIds,
        activeSort,
        errorMessage,
      ];
}
