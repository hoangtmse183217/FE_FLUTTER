import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/features/owner_dashboard/state/owner_dashboard_cubit.dart';
import 'package:mumiappfood/features/owner_dashboard/widgets/restaurant_management_card.dart';

import '../../../routes/app_router.dart';

class RestaurantManagementView extends StatelessWidget {
  const RestaurantManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    // Cubit sẽ được cung cấp bởi trang cha
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý Nhà hàng'),
        // Tự động có nút back nếu được push, nếu không thì không có

      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Điều hướng đến trang Add/Edit ở chế độ "Thêm mới" (không có ID)
          context.pushNamed(AppRouteNames.addRestaurant);
        },
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Thêm nhà hàng'),
      ),
      body: BlocBuilder<OwnerDashboardCubit, OwnerDashboardState>(
        builder: (context, state) {
          if (state is OwnerDashboardLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is OwnerDashboardError) {
            return Center(child: Text(state.message));
          }
          if (state is OwnerDashboardLoaded) {
            if (state.restaurants.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(kSpacingL),
                  child: Text(
                    'Bạn chưa có nhà hàng nào. Hãy thêm nhà hàng đầu tiên của bạn!',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(kSpacingM),
              itemCount: state.restaurants.length,
              separatorBuilder: (_, __) => vSpaceS,
              itemBuilder: (context, index) {
                return RestaurantManagementCard(restaurant: state.restaurants[index]);
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}