import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/features/role_selection/widgets/role_card.dart';
import 'package:mumiappfood/routes/app_router.dart';

import '../../../core/constants/colors.dart';

class RoleSelectionPage extends StatelessWidget {
  const RoleSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: kSpacingL),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // --- Logo ---
              SvgPicture.asset(
                'assets/images/branding/logo.svg',
                height: 90,
                colorFilter: const ColorFilter.mode(
                  AppColors.primary,
                  BlendMode.srcIn,
                ),
              ),
              vSpaceL,

              // --- Lời chào ---
              Text(
                'Chào mừng đến với MumiAppFood!',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              vSpaceS,
              Text(
                'Vui lòng chọn vai trò để tiếp tục',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary.withOpacity(0.8),
                ),
              ),
              vSpaceXL,
              vSpaceM,

              // --- Vai trò Thực khách ---
              RoleCard(
                icon: Icons.restaurant_menu_outlined,
                title: 'Tôi là Thực khách',
                subtitle: 'Khám phá, đánh giá và đặt bàn dễ dàng.',
                onTap: () => context.goNamed(AppRouteNames.login),
              ),
              vSpaceL,

              // --- Vai trò Đối tác ---
              RoleCard(
                icon: Icons.storefront_outlined,
                title: 'Tôi là Đối tác',
                subtitle: 'Quản lý nhà hàng, món ăn và phản hồi khách hàng.',
                onTap: () => context.goNamed(AppRouteNames.ownerLogin),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
