import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

part 'owner_dashboard_state.dart';

// Dữ liệu giả cho các nhà hàng của một Partner
final List<Map<String, dynamic>> _mockOwnedRestaurants = [
  {
    'id': 'my-restaurant-1',
    'name': 'Nhà hàng Bếp Việt của tôi',
    'status': 'APPROVED', // Đã được duyệt
    'address': '123 Lê Lợi, Quận 1',
  },
  {
    'id': 'my-restaurant-2',
    'name': 'Quán Cà Phê Chờ Duyệt',
    'status': 'PENDING', // Đang chờ duyệt
    'address': '456 Nguyễn Huệ, Quận 1',
  },
];

class OwnerDashboardCubit extends Cubit<OwnerDashboardState> {
  OwnerDashboardCubit() : super(OwnerDashboardInitial());

  // Tải danh sách nhà hàng của Partner
  Future<void> fetchMyRestaurants() async {
    emit(OwnerDashboardLoading());
    // TODO: Thay thế bằng logic gọi Firestore
    // Query: firestore.collection('restaurants').where('ownerId', isEqualTo: currentUser.uid)
    await Future.delayed(const Duration(seconds: 1));
    emit(OwnerDashboardLoaded(restaurants: _mockOwnedRestaurants));
  }
}