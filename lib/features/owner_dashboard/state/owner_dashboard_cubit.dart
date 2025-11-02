import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:mumiappfood/features/notifications/data/repositories/notification_repository.dart';
import 'package:mumiappfood/features/owner_dashboard/data/repositories/post_repository.dart';
import 'package:mumiappfood/features/owner_dashboard/data/repositories/restaurant_repository.dart';

part 'owner_dashboard_state.dart';

class OwnerDashboardCubit extends Cubit<OwnerDashboardState> {
  final RestaurantRepository _restaurantRepository = RestaurantRepository();
  final PostRepository _postRepository = PostRepository();
  final NotificationRepository _notificationRepository = NotificationRepository();

  OwnerDashboardCubit() : super(OwnerDashboardInitial());

  Future<void> fetchDashboardData() async {
    if (state is! OwnerDashboardLoaded) {
      emit(OwnerDashboardLoading());
    }

    try {
      final results = await Future.wait([
        _restaurantRepository.getMyRestaurants(),
        // THỬ NGHIỆM: Thay đổi pageSize từ 1000 thành 10 để kiểm tra giả thuyết
        _postRepository.getMyPosts(pageSize: 10),
        _notificationRepository.getNotifications(),
      ]);

      final restaurants = results[0] as List<dynamic>;
      final postsData = results[1] as Map<String, dynamic>;
      final posts = postsData['items'] as List<dynamic>;
      final notifications = results[2] as List<dynamic>;

      final unreadCount = notifications.where((n) => n['isRead'] == false).length;

      emit(OwnerDashboardLoaded(
        restaurants: restaurants,
        posts: posts,
        unreadNotificationCount: unreadCount,
      ));
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('Error in fetchDashboardData: $e');
        print(stackTrace);
      }
      emit(OwnerDashboardError(message: e.toString()));
    }
  }

  void refreshData() {
    fetchDashboardData();
  }

  void refreshRestaurants() {
    fetchDashboardData();
  }

  Future<void> deleteRestaurant(String restaurantId) async {
    if (state is! OwnerDashboardLoaded) return;
    final currentState = state as OwnerDashboardLoaded;

    try {
      await _restaurantRepository.deleteRestaurant(restaurantId);
      final updatedRestaurants = List<Map<String, dynamic>>.from(currentState.restaurants)
        ..removeWhere((r) => r['id'].toString() == restaurantId);

      emit(currentState.copyWith(restaurants: updatedRestaurants));

    } catch (e) {
      emit(OwnerDashboardError(message: e.toString()));
      emit(currentState);
    }
  }
}
