part of 'discover_cubit.dart';

// Enum để quản lý trạng thái tải dữ liệu
enum DiscoverStatus { initial, loading, success, failure }

@immutable
class DiscoverState extends Equatable {
  // Trạng thái hiện tại của Cubit
  final DiscoverStatus status;

  // Danh sách nhà hàng thuần túy từ API
  final List<Restaurant> originalRestaurants;

  // Danh sách nhà hàng đã được sắp xếp (FE-only) để hiển thị trên UI
  final List<Restaurant> displayedRestaurants;

  // Bộ lọc đang được áp dụng
  final DiscoverFilter activeFilter;

  // Tùy chọn sắp xếp đang được áp dụng
  final SortOption activeSort;

  // Thông báo lỗi
  final String? errorMessage;

  const DiscoverState({
    this.status = DiscoverStatus.initial,
    this.originalRestaurants = const [],
    this.displayedRestaurants = const [],
    this.activeFilter = const DiscoverFilter.empty(),
    this.activeSort = SortOption.latest,
    this.errorMessage,
  });

  DiscoverState copyWith({
    DiscoverStatus? status,
    List<Restaurant>? originalRestaurants,
    List<Restaurant>? displayedRestaurants,
    DiscoverFilter? activeFilter,
    SortOption? activeSort,
    String? errorMessage,
    bool clearError = false,
  }) {
    return DiscoverState(
      status: status ?? this.status,
      originalRestaurants: originalRestaurants ?? this.originalRestaurants,
      displayedRestaurants: displayedRestaurants ?? this.displayedRestaurants,
      activeFilter: activeFilter ?? this.activeFilter,
      activeSort: activeSort ?? this.activeSort,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        originalRestaurants,
        displayedRestaurants,
        activeFilter,
        activeSort,
        errorMessage,
      ];
}
