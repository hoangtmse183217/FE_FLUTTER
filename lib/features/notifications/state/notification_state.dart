part of 'notification_cubit.dart';

@immutable
abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {
  // Thêm thuộc tính để phân biệt lần tải đầu và các lần tải lại
  final bool isFirstFetch;
  NotificationLoading({this.isFirstFetch = false});
}

class NotificationError extends NotificationState {
  final String message;
  NotificationError(this.message);
}

class NotificationLoaded extends NotificationState {
  final List<dynamic> notifications;
  NotificationLoaded({required this.notifications});
}
