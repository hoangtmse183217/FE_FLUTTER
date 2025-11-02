import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:mumiappfood/features/owner_dashboard/data/repositories/restaurant_repository.dart';

part 'add_edit_restaurant_state.dart';

class AddEditRestaurantCubit extends Cubit<AddEditRestaurantState> {
  final RestaurantRepository _repository = RestaurantRepository();

  AddEditRestaurantCubit() : super(AddEditRestaurantInitial());

  /// Tải dữ liệu nhà hàng để sửa
  Future<void> loadRestaurantForEdit(String restaurantId) async {
    emit(AddEditRestaurantLoadingData());
    try {
      final data = await _repository.getRestaurantDetails(restaurantId);
      emit(AddEditRestaurantDataLoaded(data));
    } catch (e) {
      emit(AddEditRestaurantError(e.toString()));
    }
  }


  Future<void> addRestaurant({
    required String name,
    required String address,
    required String description,
    required double avgPrice,
    required double latitude,
    required double longitude,
  }) async {
    emit(AddEditRestaurantSaving());
    try {
      final data = {
        'name': name,
        'address': address,
        'description': description,
        'avgPrice': avgPrice,
        'latitude': latitude,
        'longitude': longitude,
      };
      await _repository.addRestaurant(data);
      emit(AddEditRestaurantSuccess());
    } catch (e) {
      emit(AddEditRestaurantError(e.toString()));
    }
  }

  /// Cập nhật nhà hàng
  Future<void> updateRestaurant({
    required String restaurantId,
    required String name,
    required String address,
    required String description,
    required double avgPrice,
    required double latitude,
    required double longitude,
  }) async {
    emit(AddEditRestaurantSaving());
    try {
      final data = {
        'name': name,
        'address': address,
        'description': description,
        'avgPrice': avgPrice,
        'latitude': latitude,
        'longitude': longitude,
      };
      await _repository.updateRestaurant(restaurantId, data);
      emit(AddEditRestaurantSuccess());
    } catch (e) {
      emit(AddEditRestaurantError(e.toString()));
    }
  }
}
