import 'package:image_picker/image_picker.dart';

import '../providers/restaurant_api_provider.dart';

class RestaurantRepository {
  final _apiProvider = RestaurantApiProvider();

  /// Thêm nhà hàng mới
  Future<Map<String, dynamic>> addRestaurant(Map<String, dynamic> data) {
    return _apiProvider.addRestaurant(data);
  }

  /// Lấy danh sách nhà hàng của đối tác (KHÔI PHỤC: Trả về đúng kiểu List mà API cung cấp)
  Future<List<Map<String, dynamic>>> getMyRestaurants() {
    return _apiProvider.fetchMyRestaurants();
  }

  /// Lấy chi tiết nhà hàng theo ID
  Future<Map<String, dynamic>> getRestaurantDetails(String restaurantId) {
    return _apiProvider.getRestaurantDetails(restaurantId);
  }

  /// Cập nhật nhà hàng
  Future<Map<String, dynamic>> updateRestaurant(String restaurantId, Map<String, dynamic> data) {
    return _apiProvider.updateRestaurant(restaurantId, data);
  }

  /// Xóa nhà hàng
  Future<void> deleteRestaurant(String restaurantId) {
    return _apiProvider.deleteRestaurant(restaurantId);
  }

  /// Tải ảnh nhà hàng
  Future<Map<String, dynamic>> uploadRestaurantImage(String restaurantId, XFile imageFile) {
    return _apiProvider.uploadRestaurantImage(restaurantId, imageFile);
  }

  Future<void> deleteRestaurantImage(String restaurantId, String imageId) {
    return _apiProvider.deleteRestaurantImage(restaurantId, imageId);
  }
}
