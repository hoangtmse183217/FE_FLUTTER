part of 'add_edit_restaurant_cubit.dart';

@immutable
abstract class AddEditRestaurantState {}

  class AddEditRestaurantInitial extends AddEditRestaurantState {}

/// State mới: Đang tải dữ liệu nhà hàng để sửa
class AddEditRestaurantLoadingData extends AddEditRestaurantState {} 

/// State mới: Dữ liệu nhà hàng đã được tải
class AddEditRestaurantDataLoaded extends AddEditRestaurantState {
  final Map<String, dynamic> restaurantData;
  AddEditRestaurantDataLoaded(this.restaurantData);
}

/// State mới: Đang lưu nhà hàng (thêm hoặc sửa)
class AddEditRestaurantSaving extends AddEditRestaurantState {} // Đổi tên từ Loading

/// State mới: Lỗi khi thêm/sửa nhà hàng
class AddEditRestaurantError extends AddEditRestaurantState {
  final String message;
  AddEditRestaurantError(this.message);
}

/// State mới: Thêm/Sửa nhà hàng thành công
class AddEditRestaurantSuccess extends AddEditRestaurantState {}
