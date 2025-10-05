part of 'discover_cubit.dart';

@immutable
abstract class DiscoverState {}

class DiscoverInitial extends DiscoverState {}

class DiscoverLoading extends DiscoverState {}

class DiscoverLoaded extends DiscoverState {
  final List<String> allMoods;
  final Set<String> selectedMoods;
  // 1. ĐỊNH NGHĨA KIỂU DỮ LIỆU CHÍNH XÁC Ở ĐÂY
  final List<Map<String, dynamic>> restaurants;
  final bool isLoading;
  final Set<String> selectedPriceRanges;
  final double minRating;

  DiscoverLoaded({
    required this.allMoods,
    required this.selectedMoods,
    required this.restaurants,
    this.isLoading = false,
    this.selectedPriceRanges = const {},
    this.minRating = 0.0,
  });

  DiscoverLoaded copyWith({
    Set<String>? selectedMoods,
    List<Map<String, dynamic>>? restaurants,
    bool? isLoading,
    Set<String>? selectedPriceRanges,
    double? minRating,
  }) {
    return DiscoverLoaded(
      allMoods: allMoods,
      selectedMoods: selectedMoods ?? this.selectedMoods,
      restaurants: restaurants ?? this.restaurants,
      isLoading: isLoading ?? this.isLoading,
      selectedPriceRanges: selectedPriceRanges ?? this.selectedPriceRanges,
      minRating: minRating ?? this.minRating,
    );
  }
}

class DiscoverError extends DiscoverState {
  final String message;
  DiscoverError({required this.message});
}