import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

part 'restaurant_images_state.dart';

class RestaurantImagesCubit extends Cubit<RestaurantImagesState> {
  final String restaurantId;
  final ImagePicker _picker = ImagePicker();

  RestaurantImagesCubit({required this.restaurantId}) : super(RestaurantImagesInitial());

  /// Tải danh sách ảnh của nhà hàng (Logic giả lập)
  Future<void> fetchImages() async {
    emit(RestaurantImagesLoading());

    // Giả lập việc gọi API để lấy danh sách URL ảnh
    await Future.delayed(const Duration(seconds: 1));

    // Giả sử API trả về danh sách này
    emit(RestaurantImagesLoaded(imageUrls: [
      'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=500',
      'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=500',
    ]));
  }

  /// Chọn và tải ảnh mới lên (Logic giả lập)
  Future<void> pickAndUploadImage() async {
    // Đảm bảo chỉ chạy khi đã tải xong dữ liệu ban đầu
    if (state is! RestaurantImagesLoaded) return;
    final currentState = state as RestaurantImagesLoaded;

    try {
      // 1. Chọn ảnh từ thư viện
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image == null) return; // Người dùng hủy, không làm gì cả

      // Luồng phụ: Kiểm tra kích thước file (ví dụ: < 5MB)
      final fileSize = await image.length();
      if (fileSize > 5 * 1024 * 1024) { // 5 MB
        // Phát ra lỗi và quay lại trạng thái cũ
        emit(RestaurantImagesError(message: 'Kích thước ảnh không được vượt quá 5MB.'));
        emit(currentState);
        return;
      }

      // Báo cho UI biết là đang tải lên
      emit(currentState.copyWith(isUploading: true));

      // 2. Giả lập việc tải file lên server và nhận lại URL
      await Future.delayed(const Duration(seconds: 2));
      const newImageUrl = 'https://images.unsplash.com/photo-1559339352-11d035aa65de?w=500';

      // 3. Cập nhật lại UI với danh sách ảnh mới
      final updatedImageUrls = List<String>.from(currentState.imageUrls)..add(newImageUrl);
      emit(currentState.copyWith(imageUrls: updatedImageUrls, isUploading: false));

    } catch (e) {
      // Xử lý các lỗi khác có thể xảy ra
      emit(RestaurantImagesError(message: 'Tải ảnh lên thất bại. Vui lòng thử lại.'));
      // Quay lại trạng thái cũ
      emit(currentState.copyWith(isUploading: false));
    }
  }

  /// Xóa một ảnh (Logic giả lập)
  void deleteImage(String imageUrlToDelete) async {
    if (state is! RestaurantImagesLoaded) return;
    final currentState = state as RestaurantImagesLoaded;

    // Cập nhật UI ngay lập tức để có trải nghiệm mượt mà
    final updatedImageUrls = List<String>.from(currentState.imageUrls)
      ..remove(imageUrlToDelete);
    emit(currentState.copyWith(imageUrls: updatedImageUrls));

    // Giả lập việc gọi API để xóa ảnh trên server
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      print('Đã xóa ảnh: $imageUrlToDelete');
      // Nếu API thành công, không cần làm gì thêm vì UI đã được cập nhật
    } catch (e) {
      // Nếu API thất bại, khôi phục lại ảnh đã xóa trên UI và báo lỗi
      print('Xóa ảnh thất bại, khôi phục lại.');
      emit(currentState); // Quay lại trạng thái ban đầu
      emit(RestaurantImagesError(message: 'Xóa ảnh thất bại.'));
    }
  }
}