import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/features/notifications/state/notification_cubit.dart';
import 'package:mumiappfood/features/notifications/widgets/notification_item.dart';
import 'package:mumiappfood/features/notifications/widgets/notification_skeleton.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../core/constants/colors.dart';

// Trang Thông báo đã được cải tiến
class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotificationCubit()..fetchNotifications(),
      child: const NotificationView(),
    );
  }
}

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  // Xử lý logic tải lại dữ liệu
  Future<void> _onRefresh(BuildContext context) async {
    context.read<NotificationCubit>().fetchNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông báo', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        centerTitle: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [
          BlocBuilder<NotificationCubit, NotificationState>(
            builder: (context, state) {
              if (state is NotificationLoaded && state.notifications.any((n) => n['isRead'] == false)) {
                return TextButton(
                  onPressed: () => context.read<NotificationCubit>().markAllAsRead(),
                  child: const Text('Đọc tất cả', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          // --- CÁC TRẠNG THÁI GIAO DIỆN ---
          if (state is NotificationInitial) {
            return _buildLoadingState();
          }
          if (state is NotificationLoading && state.isFirstFetch) {
             return _buildLoadingState();
          }
          if (state is NotificationError) {
            return _buildErrorState(context, state.message);
          }
          if (state is NotificationLoaded) {
            return RefreshIndicator(
              onRefresh: () => _onRefresh(context),
              color: AppColors.primary,
              child: state.notifications.isEmpty
                  ? _buildEmptyState(context)
                  : _buildLoadedState(context, state.notifications),
            );
          }
          // Trạng thái mặc định nếu không khớp
          return _buildLoadingState();
        },
      ),
    );
  }

  // --- CÁC WIDGET CON CHO TỪNG TRẠNG THÁI ---

  // Giao diện khi đang tải dữ liệu lần đầu
  Widget _buildLoadingState() {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(kSpacingM),
      itemCount: 8,
      separatorBuilder: (_, __) => vSpaceM,
      itemBuilder: (_, __) => const NotificationSkeleton(),
    );
  }

  // Giao diện khi có lỗi
  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(kSpacingL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(message, textAlign: TextAlign.center),
            vSpaceM,
            ElevatedButton(
              onPressed: () => _onRefresh(context),
              child: const Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }

  // Giao diện khi danh sách rỗng
  Widget _buildEmptyState(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(kSpacingL),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.notifications_off_outlined, size: 64, color: Colors.grey.shade400),
                    vSpaceM,
                    const Text('Bạn không có thông báo nào.', style: TextStyle(fontSize: 16, color: Colors.grey)),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Giao diện khi đã tải xong và có dữ liệu
  Widget _buildLoadedState(BuildContext context, List<dynamic> notifications) {
    // Sắp xếp thông báo theo thời gian mới nhất
    notifications.sort((a, b) => DateTime.parse(b['createdAt']).compareTo(DateTime.parse(a['createdAt'])));

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: kSpacingS),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final item = notifications[index];
        final int notificationId = item['id'];
        final createdAt = DateTime.parse(item['createdAt']);
        
        // TODO: Logic xác định icon và màu sắc nên được chuyển vào model hoặc helper
        IconData icon = Icons.notifications_outlined;
        if ((item['title'] as String).toLowerCase().contains('duyệt')) {
          icon = Icons.check_circle_outline;
        } else if ((item['title'] as String).toLowerCase().contains('ưu đãi')) {
          icon = Icons.local_offer_outlined;
        }

        return NotificationItem(
          notificationId: notificationId,
          icon: icon,
          title: item['title'],
          subtitle: item['content'],
          time: timeago.format(createdAt, locale: 'vi'),
          isRead: item['isRead'],
          onTap: () {
            context.read<NotificationCubit>().markAsRead(notificationId);
          },
        );
      },
    );
  }
}
