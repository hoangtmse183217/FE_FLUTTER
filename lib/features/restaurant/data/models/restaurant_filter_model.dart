
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// Enum cho các tùy chọn sắp xếp (FE-only)
enum SortOption {
  latest, // Mặc định từ API
  nameAZ,
  nameZA,
  priceAsc,
  priceDesc,
  ratingDesc,
  distance, // Sắp xếp theo khoảng cách gần nhất
}

// Lớp chứa tất cả các tham số lọc
class RestaurantFilter extends Equatable {
  final String? query;
  final LatLng? location; // Vị trí người dùng chọn
  final double? radiusKm;
  final double? minPrice;
  final double? maxPrice;
  final double? minRating;

  const RestaurantFilter({
    this.query,
    this.location,
    this.radiusKm,
    this.minPrice,
    this.maxPrice,
    this.minRating,
  });

  // Constructor rỗng để thể hiện trạng thái không có bộ lọc
  const RestaurantFilter.empty()
      : query = null,
        location = null,
        radiusKm = null,
        minPrice = null,
        maxPrice = null,
        minRating = null;

  // Giúp dễ dàng copy và thay đổi một vài giá trị
  RestaurantFilter copyWith({
    String? query,
    LatLng? location,
    double? radiusKm,
    double? minPrice,
    double? maxPrice,
    double? minRating,
  }) {
    return RestaurantFilter(
      query: query ?? this.query,
      location: location ?? this.location,
      radiusKm: radiusKm ?? this.radiusKm,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      minRating: minRating ?? this.minRating,
    );
  }

  @override
  List<Object?> get props => [query, location, radiusKm, minPrice, maxPrice, minRating];
}
