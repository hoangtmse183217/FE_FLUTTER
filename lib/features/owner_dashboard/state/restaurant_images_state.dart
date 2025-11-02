part of 'restaurant_images_cubit.dart';

@immutable
abstract class RestaurantImagesState {}

class RestaurantImagesInitial extends RestaurantImagesState {}

class RestaurantImagesLoading extends RestaurantImagesState {}

class RestaurantImagesError extends RestaurantImagesState {
  final String message;
  RestaurantImagesError({required this.message});
}

class RestaurantImagesLoaded extends RestaurantImagesState {
  final List<Map<String, dynamic>> imagesData;
  final bool isUploading;

  RestaurantImagesLoaded({
    required this.imagesData,
    this.isUploading = false,
  });

  RestaurantImagesLoaded copyWith({
    List<Map<String, dynamic>>? imagesData,
    bool? isUploading,
  }) {
    return RestaurantImagesLoaded(
      imagesData: imagesData ?? this.imagesData,
      isUploading: isUploading ?? this.isUploading,
    );
  }
}
