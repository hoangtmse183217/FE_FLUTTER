// lib/features/home/widgets/home_search_bar.dart

import 'package:flutter/material.dart';
import 'package:mumiappfood/core/constants/app_icons.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/core/constants/colors.dart';

class HomeSearchBar extends StatelessWidget {
  final VoidCallback? onFilterTap; // <-- Thêm callback

  const HomeSearchBar({super.key, this.onFilterTap});

  @override
  Widget build(BuildContext context) {
    // Sử dụng InkWell để có hiệu ứng gợn sóng khi nhấn
    return InkWell(
      onTap: () {
        // TODO: Điều hướng đến trang tìm kiếm chuyên dụng
        // Ví dụ: context.goNamed(AppRouteNames.search);
        print('Navigate to Search Page');
      },
      borderRadius: BorderRadius.circular(30.0), // Bo tròn cho hiệu ứng
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: kSpacingM, vertical: 12.0),
        decoration: BoxDecoration(
          // Sử dụng màu nền của Card từ theme
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(30.0),
          // Thêm một đường viền tinh tế
          border: Border.all(color: AppColors.border),
          // Hoặc thêm bóng đổ (shadow) để tạo chiều sâu
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.black.withOpacity(0.05),
          //     blurRadius: 10,
          //     offset: const Offset(0, 4),
          //   ),
          // ],
        ),
        child: Row(
          children: [
            // Icon tìm kiếm
            Icon(AppIcons.search, color: Colors.grey[600]),
            hSpaceS,
            // Dùng Expanded để Text chiếm hết không gian còn lại
            Expanded(
              child: Text(
                'Tìm nhà hàng, ẩm thực...', // Cập nhật hint text cho phù hợp
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
              ),
            ),
            InkWell(
              onTap: onFilterTap,
              child: Padding(
                padding: const EdgeInsets.all(4.0), // Tăng vùng nhấn
                child: Icon(Icons.tune_outlined, color: Theme.of(context).primaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}