import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/routes/app_router.dart';
import '../../../core/constants/colors.dart';

class RoleSelectionPage extends StatelessWidget {
  const RoleSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(kSpacingL),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch, 
            children: [
              const Spacer(flex: 2),
              // --- THAY ĐỔI: Xóa colorFilter để giữ màu gốc của logo ---
              SvgPicture.asset(
                'assets/images/branding/logo.svg',
                height: 100, 
              ),
              vSpaceXL,

              Text(
                'Chào mừng bạn!',
                textAlign: TextAlign.center,
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              vSpaceS,
              Text(
                'Bắt đầu hành trình ẩm thực của bạn với vai trò là...',
                textAlign: TextAlign.center,
                style: textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(flex: 1),
              
              // --- THAY ĐỔI: Cả hai nút giờ đều là ElevatedButton ---
              _buildRoleButton(
                context: context,
                icon: Icons.restaurant_menu_outlined,
                label: 'THỰC KHÁCH',
                onPressed: () => context.goNamed(AppRouteNames.login),
              ),
              vSpaceM,
              _buildRoleButton(
                context: context,
                icon: Icons.storefront_outlined,
                label: 'ĐỐI TÁC NHÀ HÀNG',
                onPressed: () => context.goNamed(AppRouteNames.ownerLogin),
              ),
              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    // Style chung cho cả hai nút
    final buttonStyle = ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: kSpacingM),
            textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          );

    final content = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 22),
        hSpaceM,
        Text(label),
      ],
    );

    return ElevatedButton(onPressed: onPressed, style: buttonStyle, child: content);
  }
}
