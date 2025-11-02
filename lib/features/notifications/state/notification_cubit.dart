import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:mumiappfood/features/notifications/data/repositories/notification_repository.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationRepository _repository = NotificationRepository();

  NotificationCubit() : super(NotificationInitial());

  /// Lấy danh sách thông báo từ API
  Future<void> fetchNotifications() async {
    // SỬA ĐỔI: Thêm logic để xác định lần tải đầu tiên
    final isFirstFetch = state is NotificationInitial;
    emit(NotificationLoading(isFirstFetch: isFirstFetch));
    
    try {
      final List<dynamic> notifications = await _repository.getNotifications();
      emit(NotificationLoaded(notifications: notifications));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  /// Đánh dấu một thông báo là đã đọc với Optimistic Update
  Future<void> markAsRead(int notificationId) async {
    if (state is! NotificationLoaded) return;
    
    final currentState = state as NotificationLoaded;
    final int index = currentState.notifications.indexWhere((n) => n['id'] == notificationId);
    
    if (index == -1 || currentState.notifications[index]['isRead'] == true) return;
    
    try {
      final List<dynamic> updatedNotifications = List.from(currentState.notifications);
      updatedNotifications[index]['isRead'] = true;
      emit(NotificationLoaded(notifications: updatedNotifications));
      
      await _repository.markAsRead(notificationId);
      if (kDebugMode) {
        print('Đã đánh dấu thông báo $notificationId là đã đọc.');
      }

    } catch (e) {
      if (kDebugMode) {
        print('Lỗi khi đánh dấu đã đọc: $e. Hoàn tác lại UI.');
      }
      final List<dynamic> revertedNotifications = List.from(currentState.notifications);
      revertedNotifications[index]['isRead'] = false;
      emit(NotificationLoaded(notifications: revertedNotifications));
    }
  }

  /// Đánh dấu tất cả thông báo là đã đọc với Optimistic Update
  Future<void> markAllAsRead() async {
    if (state is! NotificationLoaded) return;
    final currentState = state as NotificationLoaded;

    final originalNotifications = List<Map<String, dynamic>>.from(
      currentState.notifications.map((n) => Map<String, dynamic>.from(n))
    );

    try {
      final updatedNotifications = currentState.notifications.map((notification) {
        return {...notification, 'isRead': true};
      }).toList();
      emit(NotificationLoaded(notifications: updatedNotifications));
      
      await _repository.markAllAsRead();
      if (kDebugMode) {
        print('Đã đánh dấu tất cả thông báo là đã đọc.');
      }

    } catch (e) {
      if (kDebugMode) {
        print('Lỗi khi đánh dấu tất cả đã đọc: $e. Hoàn tác lại UI.');
      }
      emit(NotificationLoaded(notifications: originalNotifications));
    }
  }
}
