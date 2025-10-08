import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mumiappfood/core/constants/colors.dart';
import 'package:mumiappfood/routes/app_router.dart';

class RestaurantManagementCard extends StatelessWidget {
  final Map<String, dynamic> restaurant;

  const RestaurantManagementCard({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    final status = restaurant['status'];
    final isPending = status == 'PENDING';

    final Color statusColor = isPending ? Colors.orange.shade700 : Colors.green.shade700;
    final String statusText = isPending ? 'Chờ duyệt' : 'Đã duyệt';

    return Card(
      elevation: 2,
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      shadowColor: AppColors.primary.withOpacity(0.1),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        leading: const Icon(Icons.storefront, size: 40, color: AppColors.primary),
        title: Text(
          restaurant['name'],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                restaurant['address'],
                style: const TextStyle(color: AppColors.textSecondary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),

        // --- Menu thao tác ---
        trailing: Theme(
          data: Theme.of(context).copyWith(
            popupMenuTheme: PopupMenuThemeData(
              color: AppColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          child: PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: AppColors.textSecondary),
            // --- CẬP NHẬT onSelected ---
            onSelected: (value) {
              final restaurantId = restaurant['id'];
              if (restaurantId == null) return; // Biện pháp an toàn

              if (value == 'edit') {
                context.pushNamed(
                  AppRouteNames.editRestaurant,
                  pathParameters: {'restaurantId': restaurantId},
                );
              } else if (value == 'images') {
                // ĐIỀU HƯỚNG ĐẾN TRANG QUẢN LÝ ẢNH
                context.pushNamed(
                  AppRouteNames.restaurantImages,
                  pathParameters: {'restaurantId': restaurantId},
                );
              } else if (value == 'delete') {
                // TODO: Hiển thị dialog xác nhận trước khi xóa
                print('Xóa nhà hàng: $restaurantId');
              }
            },
            // --- CẬP NHẬT itemBuilder ---
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit_outlined, color: AppColors.textSecondary),
                    SizedBox(width: 12),
                    Text('Sửa thông tin'),
                  ],
                ),
              ),
              // THÊM MỤC "QUẢN LÝ ẢNH"
              const PopupMenuItem<String>(
                value: 'images',
                child: Row(
                  children: [
                    Icon(Icons.photo_library_outlined, color: AppColors.textSecondary),
                    SizedBox(width: 12),
                    Text('Quản lý ảnh'),
                  ],
                ),
              ),
              if (isPending)
                const PopupMenuItem<String>(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline, color: Colors.redAccent),
                      SizedBox(width: 12),
                      Text(
                        'Xóa',
                        style: TextStyle(color: Colors.redAccent),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}