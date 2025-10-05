import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

part 'restaurant_details_state.dart';

// Dữ liệu giả cho một nhà hàng
final Map<String, dynamic> _mockRestaurantData = {
  'id': '123',
  'name': 'The Deck Saigon',
  'description': 'Một nhà hàng ven sông lãng mạn với không gian mở và tầm nhìn tuyệt đẹp. Chuyên phục vụ các món ăn Âu - Á kết hợp, là địa điểm lý tưởng cho các buổi hẹn hò và dịp đặc biệt.',
  'address': '38 Nguyễn Ư Dĩ, Thảo Điền, Quận 2, TP.HCM',
  'rating': 4.7,
  'priceRange': '₫₫₫ (300k - 700k)',
  'cuisine': 'Món Âu & Việt',
  'images': [
    'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=500',
    'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=500',
    'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=500',
  ],
  'latitude': 10.8016,
  'longitude': 106.7383,
};

class RestaurantDetailsCubit extends Cubit<RestaurantDetailsState> {
  RestaurantDetailsCubit() : super(RestaurantDetailsInitial());

  Future<void> fetchRestaurantDetails(String restaurantId) async {
    emit(RestaurantDetailsLoading());
    // Giả lập cuộc gọi API dựa trên restaurantId
    await Future.delayed(const Duration(seconds: 1));

    // Logic thực tế:
    // try {
    //   final data = await firestore.collection('restaurants').doc(restaurantId).get();
    //   if (data.exists) {
    //     emit(RestaurantDetailsLoaded(restaurantData: data.data()!));
    //   } else {
    //     emit(RestaurantDetailsError(message: 'Không tìm thấy nhà hàng.'));
    //   }
    // } catch (e) { ... }

    emit(RestaurantDetailsLoaded(restaurantData: _mockRestaurantData));
  }
}