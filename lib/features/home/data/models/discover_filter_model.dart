import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// Lớp này giờ đây chỉ chứa các tham số lọc cho Discovery
class DiscoverFilter extends Equatable {
  final String? query;
  final LatLng? location;
  final double? radiusKm;
  final double? minPrice;
  final double? maxPrice;
  final double? minRating;

  const DiscoverFilter({
    this.query,
    this.location,
    this.radiusKm,
    this.minPrice,
    this.maxPrice,
    this.minRating,
  });

  const DiscoverFilter.empty()
      : query = null,
        location = null,
        radiusKm = null,
        minPrice = null,
        maxPrice = null,
        minRating = null;

  DiscoverFilter copyWith({
    String? query,
    LatLng? location,
    double? radiusKm,
    double? minPrice,
    double? maxPrice,
    double? minRating,
  }) {
    return DiscoverFilter(
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
