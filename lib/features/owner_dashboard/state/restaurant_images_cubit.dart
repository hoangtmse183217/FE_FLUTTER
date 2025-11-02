import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mumiappfood/features/owner_dashboard/data/repositories/restaurant_repository.dart';

part 'restaurant_images_state.dart';

class RestaurantImagesCubit extends Cubit<RestaurantImagesState> {
  final String restaurantId;
  final ImagePicker _picker = ImagePicker();
  final RestaurantRepository _repository = RestaurantRepository();

  RestaurantImagesCubit({required this.restaurantId}) : super(RestaurantImagesInitial());

  /// Tải danh sách ảnh của nhà hàng từ API
  Future<void> fetchImages() async {
    emit(RestaurantImagesLoading());
    try {
      final restaurantData = await _repository.getRestaurantDetails(restaurantId);
      final images = List<Map<String, dynamic>>.from(restaurantData['images'] ?? []);
      emit(RestaurantImagesLoaded(imagesData: images));
    } catch (e) {
      emit(RestaurantImagesError(message: 'Không thể tải danh sách ảnh: ${e.toString()}'));
    }
  }

  /// Chọn và tải ảnh mới lên
  Future<void> pickAndUploadImage() async {
    if (state is! RestaurantImagesLoaded) return;
    final currentState = state as RestaurantImagesLoaded;

    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final fileSize = await image.length();
      if (fileSize > 5 * 1024 * 1024) { // 5MB
        emit(RestaurantImagesError(message: 'Kích thước ảnh không được vượt quá 5MB.'));
        emit(currentState);
        return;
      }

      emit(currentState.copyWith(isUploading: true));

      final newImageData = await _repository.uploadRestaurantImage(restaurantId, image);

      final updatedImages = List<Map<String, dynamic>>.from(currentState.imagesData)..add(newImageData);
      emit(currentState.copyWith(imagesData: updatedImages, isUploading: false));
    } catch (e) {
      emit(RestaurantImagesError(message: 'Tải ảnh lên thất bại: ${e.toString()}'));
      emit(currentState.copyWith(isUploading: false));
    }
  }

  /// Xóa một ảnh
  Future<void> deleteImage(String imageId) async {
    if (state is! RestaurantImagesLoaded) return;
    final currentState = state as RestaurantImagesLoaded;
    final originalImages = List<Map<String, dynamic>>.from(currentState.imagesData);

    try {
      final updatedImages = List<Map<String, dynamic>>.from(originalImages)
        ..removeWhere((img) => img['id'].toString() == imageId);
      emit(currentState.copyWith(imagesData: updatedImages));

      await _repository.deleteRestaurantImage(restaurantId, imageId);
      
    } catch (e) {
      emit(currentState.copyWith(imagesData: originalImages));
      emit(RestaurantImagesError(message: 'Xóa ảnh thất bại: ${e.toString()}'));
    }
  }
}
