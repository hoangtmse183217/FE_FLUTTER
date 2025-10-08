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
  // Dữ liệu giả, bạn sẽ thay thế bằng model Restaurant
  final List<Map<String, dynamic>> restaurants;
  OwnerDashboardLoaded({required this.restaurants});
}