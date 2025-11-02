part of 'owner_dashboard_cubit.dart';

@immutable
abstract class OwnerDashboardState {}

class OwnerDashboardInitial extends OwnerDashboardState {}

class OwnerDashboardLoading extends OwnerDashboardState {}

class OwnerDashboardError extends OwnerDashboardState {
  final String message;

  OwnerDashboardError({required this.message});
}

class OwnerDashboardLoaded extends OwnerDashboardState {
  final List<dynamic> restaurants;
  final List<dynamic> posts;
  final int unreadNotificationCount; // <-- SỬA LỖI: Thêm thuộc tính này

  OwnerDashboardLoaded({
    required this.restaurants,
    required this.posts,
    this.unreadNotificationCount = 0, // <-- SỬA LỖI: Thêm vào constructor
  });

  OwnerDashboardLoaded copyWith({
    List<dynamic>? restaurants,
    List<dynamic>? posts,
    int? unreadNotificationCount, // <-- SỬA LỖI: Thêm vào copyWith
  }) {
    return OwnerDashboardLoaded(
      restaurants: restaurants ?? this.restaurants,
      posts: posts ?? this.posts,
      unreadNotificationCount: unreadNotificationCount ?? this.unreadNotificationCount,
    );
  }
}
