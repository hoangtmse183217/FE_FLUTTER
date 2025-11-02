import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/core/constants/colors.dart';
import 'package:mumiappfood/features/owner_dashboard/state/owner_dashboard_cubit.dart';
import 'package:mumiappfood/features/owner_dashboard/widgets/dashboard_stats_card.dart';
import 'package:mumiappfood/routes/app_router.dart';


class DashboardHomeView extends StatelessWidget {
  final Function(int) onNavigate;
  const DashboardHomeView({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OwnerDashboardCubit, OwnerDashboardState>(
      builder: (context, state) {
        if (state is OwnerDashboardLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is OwnerDashboardError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Lỗi: ${state.message}'),
            ),
          );
        }
        if (state is OwnerDashboardLoaded) {
          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async => context.read<OwnerDashboardCubit>().refreshData(),
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                _buildQuickActions(context),
                _buildSectionHeader(context, 'Thống kê'),
                _buildStatsGrid(context, state),
                _buildSectionHeader(context, 'Quản lý'),
                _buildManagementList(context),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  SliverToBoxAdapter _buildSectionHeader(BuildContext context, String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(kSpacingM, kSpacingXL, kSpacingM, kSpacingS),
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildQuickActions(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(kSpacingM, kSpacingM, kSpacingM, 0),
        child: Row(
          children: [
            Expanded(
              child: _QuickActionButton(
                icon: Icons.add_business_outlined,
                label: 'Thêm nhà hàng',
                onTap: () => context.pushNamed(AppRouteNames.addRestaurant),
              ),
            ),
            hSpaceM,
            Expanded(
              child: _QuickActionButton(
                icon: Icons.post_add_outlined,
                label: 'Thêm bài viết',
                onTap: () => context.pushNamed(AppRouteNames.addPost),
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverPadding _buildStatsGrid(BuildContext context, OwnerDashboardLoaded state) {
    final totalRestaurants = state.restaurants.length;
    final totalPosts = state.posts.length;
    // SỬA LỖI: Thêm ép kiểu `as List?` để đảm bảo type safety
    final totalReviews = state.restaurants.fold<int>(0, (sum, r) => sum + ((r['reviews'] as List?)?.length ?? 0));
    final unreadNotifications = state.unreadNotificationCount;

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: kSpacingM),
      sliver: SliverGrid.count(
        crossAxisCount: 2,
        crossAxisSpacing: kSpacingM,
        mainAxisSpacing: kSpacingM,
        children: [
          DashboardStatsCard(title: 'Nhà hàng', value: totalRestaurants.toString(), icon: Icons.store_outlined, color: Colors.blue, onTap: () => onNavigate(1)),
          DashboardStatsCard(title: 'Bài viết', value: totalPosts.toString(), icon: Icons.article_outlined, color: Colors.green, onTap: () => onNavigate(2)),
          DashboardStatsCard(title: 'Đánh giá', value: totalReviews.toString(), icon: Icons.reviews_outlined, color: Colors.orange, onTap: () => onNavigate(3)),
          DashboardStatsCard(title: 'Thông báo', value: unreadNotifications.toString(), icon: Icons.notifications_outlined, color: Colors.red, onTap: () => context.pushNamed(AppRouteNames.notifications)),
        ],
      ),
    );
  }

  SliverPadding _buildManagementList(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(kSpacingM),
      sliver: SliverList.separated(
        itemCount: 3,
        separatorBuilder: (context, index) => vSpaceM,
        itemBuilder: (context, index) {
          final items = [
            _ManagementListItem(title: 'Quản lý nhà hàng', subtitle: 'Xem, sửa hoặc xóa nhà hàng của bạn', icon: Icons.storefront_outlined, onTap: () => onNavigate(1)),
            _ManagementListItem(title: 'Quản lý bài viết', subtitle: 'Tạo và quảng bá các bài đăng mới', icon: Icons.campaign_outlined, onTap: () => onNavigate(2)),
            _ManagementListItem(title: 'Phản hồi của khách', subtitle: 'Xem và trả lời các đánh giá gần đây', icon: Icons.chat_bubble_outline, onTap: () => onNavigate(3)),
          ];
          return items[index];
        },
      ),
    );
  }
}


// Các Widget con để làm sạch code

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primary.withOpacity(0.1),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: kSpacingS, vertical: kSpacingL),
          child: Column(
            children: [
              Icon(icon, color: AppColors.primary, size: 28),
              vSpaceS,
              Text(label, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.primary)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ManagementListItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _ManagementListItem({required this.title, required this.subtitle, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(12),
      elevation: 0.5,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(kSpacingM),
          child: Row(
            children: [
              Icon(icon, size: 32, color: AppColors.textSecondary),
              hSpaceL,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    vSpaceXS,
                    Text(subtitle, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}
