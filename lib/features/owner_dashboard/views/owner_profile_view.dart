// lib/features/owner_dashboard/views/owner_profile_view.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/features/home/state/home_cubit.dart';
import 'package:mumiappfood/features/home/widgets/profile/profile_menu_item.dart';

class OwnerProfileView extends StatelessWidget {
  const OwnerProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    // Lấy thông tin người dùng hiện tại
    final user = FirebaseAuth.instance.currentUser;
    // Lấy ký tự đầu của tên để làm fallback cho avatar
    final fallbackText = user?.displayName?.substring(1, 8).toUpperCase() ?? 'P';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hồ sơ Đối tác'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(kSpacingM),
        child: Column(
          children: [
            // Thông tin avatar và tên
            CircleAvatar(
              radius: 50,
              backgroundImage: user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
              child: user?.photoURL == null ? Text(fallbackText, style: const TextStyle(fontSize: 40)) : null,
            ),
            vSpaceM,
            Text(
              // Loại bỏ prefix [OWNER] khi hiển thị
              user?.displayName?.replaceFirst('[OWNER] ', '') ?? 'Đối tác',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(
              user?.email ?? 'Không có email',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            vSpaceXL,

            // Các mục quản lý
            Card(
              child: Column(
                children: [
                  ProfileMenuItem(
                    icon: Icons.person_outline,
                    title: 'Chỉnh sửa hồ sơ',
                    onTap: () {
                      // TODO: Điều hướng đến trang chỉnh sửa hồ sơ chi tiết cho Owner
                    },
                  ),
                  const Divider(height: 1),
                  ProfileMenuItem(
                    icon: Icons.security_outlined,
                    title: 'Đổi mật khẩu',
                    onTap: () {},
                  ),
                ],
              ),
            ),
            vSpaceL,

            // Nút đăng xuất
            Card(
              child: ProfileMenuItem(
                icon: Icons.logout,
                title: 'Đăng xuất',
                onTap: () {
                  context.read<HomeCubit>().logout();
                },
                isEditable: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}