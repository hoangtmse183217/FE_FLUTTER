// lib/features/owner_dashboard/views/owner_profile_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/core/services/auth_service.dart';
import 'package:mumiappfood/core/widgets/app_snackbar.dart';
import 'package:mumiappfood/features/home/state/home_cubit.dart';
import 'package:mumiappfood/features/home/widgets/profile/profile_menu_item.dart';
import 'package:mumiappfood/routes/app_router.dart';

class OwnerProfileView extends StatefulWidget {
  const OwnerProfileView({super.key});

  @override
  State<OwnerProfileView> createState() => _OwnerProfileViewState();
}

class _OwnerProfileViewState extends State<OwnerProfileView> {
  // Sử dụng StatefulWidget để tải dữ liệu một lần
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _loadUserDataFromToken();
  }

  Future<void> _loadUserDataFromToken() async {
    final token = await AuthService.getAccessToken();
    if (token != null && !JwtDecoder.isExpired(token)) {
      setState(() {
        _userData = JwtDecoder.decode(token);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_userData == null) {
      // Hiển thị loading trong khi chờ giải mã token
      return Scaffold(
        appBar: AppBar(title: const Text('Hồ sơ Đối tác')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final String displayName = _userData!['fullname']?.replaceFirst('[OWNER] ', '') ?? 'Đối tác';
    final String email = _userData!['email'] ?? 'Không có email';
    final String fallbackText = displayName.isNotEmpty ? displayName.substring(0, 1).toUpperCase() : 'P';

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
              // TODO: Thay thế bằng photoURL từ API profile
              child: Text(fallbackText, style: const TextStyle(fontSize: 40)),
            ),
            vSpaceM,
            Text(
              displayName,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(
              email,
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

            // --- PHẦN ĐĂNG XUẤT ĐÃ ĐƯỢC CẬP NHẬT ---
            BlocListener<HomeCubit, HomeState>(
              listener: (context, state) {
                if (state is HomeLogoutSuccess) {
                  context.goNamed(AppRouteNames.roleSelection);
                } else if (state is HomeError) {
                  AppSnackbar.showError(context, state.message);
                }
              },
              child: Card(
                child: ProfileMenuItem(
                  icon: Icons.logout,
                  title: 'Đăng xuất',
                  onTap: () {
                    // Chỉ cần gọi hàm logout, BlocListener sẽ lo phần còn lại.
                    context.read<HomeCubit>().logout();
                  },
                  isEditable: false,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}