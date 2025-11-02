import '../providers/notification_api_provider.dart';

class NotificationRepository {
  final _apiProvider = NotificationApiProvider();

  // SỬA LỖI: API trả về một List, không phải Map.
  Future<List<dynamic>> getNotifications() {
    return _apiProvider.getNotifications();
  }

  /// Đánh dấu thông báo đã đọc
  Future<void> markAsRead(int notificationId) {
    return _apiProvider.markNotificationAsRead(notificationId);
  }

  /// Đánh dấu tất cả thông báo đã đọc
  Future<void> markAllAsRead() {
    return _apiProvider.markAllNotificationsAsRead();
  }
}
