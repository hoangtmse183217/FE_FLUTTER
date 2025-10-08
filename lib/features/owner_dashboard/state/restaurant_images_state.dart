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
  final List<String> imageUrls;
  final bool isUploading;

  RestaurantImagesLoaded({
    required this.imageUrls,
    this.isUploading = false,
  });

  RestaurantImagesLoaded copyWith({
    List<String>? imageUrls,
    bool? isUploading,
  }) {
    return RestaurantImagesLoaded(
      imageUrls: imageUrls ?? this.imageUrls,
      isUploading: isUploading ?? this.isUploading,
    );
  }
}