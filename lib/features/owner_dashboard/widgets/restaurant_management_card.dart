import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/core/constants/colors.dart';
import 'package:mumiappfood/core/widgets/app_snackbar.dart';
import 'package:mumiappfood/features/owner_dashboard/state/owner_dashboard_cubit.dart';
import 'package:mumiappfood/routes/app_router.dart';

class RestaurantManagementCard extends StatelessWidget {
  final Map<String, dynamic> restaurant;

  const RestaurantManagementCard({super.key, required this.restaurant});

  // --- PRIVATE HELPERS ---

  ({Color color, String text}) _getStatusInfo() {
    final status = (restaurant['status'] as String?)?.toLowerCase();
    switch (status) {
      case 'pending':
        return (color: Colors.orange.shade700, text: 'Chờ duyệt');
      case 'approved':
        return (color: Colors.green.shade700, text: 'Đã duyệt');
      case 'declined':
        return (color: Colors.red.shade700, text: 'Bị từ chối');
      default:
        return (color: Colors.grey, text: 'Không rõ');
    }
  }

  Future<void> _showDeleteConfirmationDialog(BuildContext context, String restaurantId, String restaurantName) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: Text('Bạn có chắc chắn muốn xóa nhà hàng "$restaurantName"? Hành động này không thể hoàn tác.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Hủy'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Xóa'),
            ),
          ],
        );
      },
    );

    if (confirmed == true && context.mounted) {
      context.read<OwnerDashboardCubit>().deleteRestaurant(restaurantId).then((_) {
         if (context.mounted) AppSnackbar.showSuccess(context, 'Đã xóa nhà hàng thành công.');
      }).catchError((e) {
         if (context.mounted) AppSnackbar.showError(context, 'Xóa nhà hàng thất bại: $e');
      });
    }
  }
  
  // --- BUILD METHOD ---

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    // TRẢ VỀ THIẾT KẾ CARD CŨ VỚI BÓNG ĐỔ
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      shadowColor: Colors.black.withOpacity(0.1),
      child: InkWell(
        onTap: () {
           final restaurantId = restaurant['id']?.toString();
           if (restaurantId == null) return;
           context.pushNamed(
              AppRouteNames.editRestaurant,
              pathParameters: {'restaurantId': restaurantId},
           ).then((result) {
              // Refresh if the edit page returns true
              if (result == true && context.mounted) {
                 context.read<OwnerDashboardCubit>().refreshRestaurants();
              }
           });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageWithStatus(context, _getStatusInfo()),
            _buildInfoPanel(context, textTheme),
          ],
        ),
      ),
    );
  }

  Widget _buildImageWithStatus(BuildContext context, ({Color color, String text}) statusInfo) {
    final images = restaurant['images'] as List<dynamic>?;
    final String? imageUrl = (images != null && images.isNotEmpty) ? images.first['imageUrl'] as String? : null;

    return Stack(
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Container(
            color: AppColors.surface,
            child: imageUrl != null
                ? Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) =>
                        progress == null ? child : const Center(child: CircularProgressIndicator()),
                    errorBuilder: (context, error, stackTrace) =>
                        const Center(child: Icon(Icons.storefront, color: AppColors.textSecondary, size: 48)),
                  )
                : const Center(child: Icon(Icons.storefront, color: AppColors.textSecondary, size: 48)),
          ),
        ),
        Positioned(
          top: kSpacingS,
          right: kSpacingS,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusInfo.color,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              statusInfo.text,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoPanel(BuildContext context, TextTheme textTheme) {
    final rating = (restaurant['rating'] as num?)?.toDouble() ?? 0.0;

     return Padding(
      padding: const EdgeInsets.fromLTRB(kSpacingM, kSpacingM, kSpacingS, kSpacingM),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  restaurant['name'] ?? 'Chưa có tên',
                  style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                vSpaceXS,
                Text(
                  restaurant['address'] ?? 'Chưa có địa chỉ',
                  style: textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (rating > 0)
                  Padding(
                    padding: const EdgeInsets.only(top: kSpacingS),
                    child: Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        hSpaceXS,
                        Text(
                          rating.toStringAsFixed(1),
                          style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: AppColors.textSecondary),
            onSelected: (value) {
              final restaurantId = restaurant['id']?.toString();
              if (restaurantId == null) return;

              if (value == 'edit') {
                 context.pushNamed(
                    AppRouteNames.editRestaurant,
                    pathParameters: {'restaurantId': restaurantId},
                 ).then((result) {
                    if (result == true && context.mounted) {
                       context.read<OwnerDashboardCubit>().refreshRestaurants();
                    }
                 });
              } else if (value == 'images') {
                context.pushNamed(
                  AppRouteNames.restaurantImages,
                  pathParameters: {'restaurantId': restaurantId},
                );
              } else if (value == 'delete') {
                _showDeleteConfirmationDialog(context, restaurantId, restaurant['name'] ?? '');
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem<String>(value: 'edit', child: Text('Chỉnh sửa')),
              const PopupMenuItem<String>(value: 'images', child: Text('Quản lý ảnh')),
              const PopupMenuItem<String>(
                value: 'delete',
                child: Text('Xóa', style: TextStyle(color: AppColors.error)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
