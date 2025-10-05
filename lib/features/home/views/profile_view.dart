import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/features/home/state/home_cubit.dart';
import 'package:mumiappfood/features/home/widgets/profile_avatar.dart';
import 'package:mumiappfood/features/home/widgets/profile_menu_item.dart';

// Lớp này vẫn chịu trách nhiệm cung cấp Cubit
class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()..loadUserData(),
      child: const ProfileContent(),
    );
  }
}

// Chuyển thành StatefulWidget để quản lý dữ liệu form
class ProfileContent extends StatefulWidget {
  const ProfileContent({super.key});

  @override
  State<ProfileContent> createState() => _ProfileContentState();
}

class _ProfileContentState extends State<ProfileContent> {
  // Biến state để lưu trữ thông tin người dùng
  String? _displayName;
  String? _photoURL;
  String _phoneNumber = 'Chưa cập nhật'; // Dữ liệu giả
  String _address = 'Chưa cập nhật';     // Dữ liệu giả
  String _gender = 'Nam';                 // Dữ liệu giả
  XFile? _newAvatarFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hồ sơ của tôi'),
        actions: [
          // Nút lưu thay đổi
          TextButton(
            onPressed: () {
              // TODO: Gọi Cubit để lưu thông tin
              // homeCubit.updateProfile(
              //   displayName: _displayName,
              //   phoneNumber: _phoneNumber,
              //   address: _address,
              //   gender: _gender,
              //   avatarFile: _newAvatarFile,
              // );
              print('Lưu thay đổi');
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
      body: BlocConsumer<HomeCubit, HomeState>(
        // Dùng BlocConsumer để vừa lắng nghe vừa build
        listener: (context, state) {
          // Cập nhật state cục bộ khi dữ liệu từ Cubit được tải xong
          if (state is HomeLoaded) {
            setState(() {
              _displayName = state.user.displayName;
              _photoURL = state.user.photoURL;
              // TODO: Lấy các thông tin khác (phone, address...) từ Firestore
            });
          }
        },
        builder: (context, state) {
          if (state is HomeLoaded) {
            final User user = state.user;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(kSpacingM),
              child: Column(
                children: [
                  ProfileAvatar(
                    photoURL: _photoURL,
                    fallbackText: _displayName?.substring(0, 1) ?? 'U',
                    onImageSelected: (imageFile) {
                      setState(() {
                        _newAvatarFile = imageFile;
                        // TODO: Hiển thị ảnh mới ngay lập tức (dùng Image.file)
                      });
                      print('Ảnh mới đã được chọn: ${imageFile.path}');
                    },
                  ),
                  vSpaceM,
                  Text(
                    _displayName ?? 'Người dùng',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Text(user.email ?? 'Không có email', style: Theme.of(context).textTheme.bodyMedium),
                  vSpaceXL,

                  // Phần thông tin có thể chỉnh sửa
                  Card(
                    child: Column(
                      children: [
                        ProfileMenuItem(
                          icon: Icons.person_outline,
                          title: 'Tên hiển thị',
                          value: _displayName,
                          onTap: () {
                            // TODO: Mở dialog/trang mới để sửa tên
                          },
                        ),
                        const Divider(height: 1),
                        ProfileMenuItem(
                          icon: Icons.phone_outlined,
                          title: 'Số điện thoại',
                          value: _phoneNumber,
                          onTap: () {
                            // TODO: Mở dialog/trang mới để sửa SĐT
                          },
                        ),
                        const Divider(height: 1),
                        ProfileMenuItem(
                          icon: Icons.location_on_outlined,
                          title: 'Địa chỉ',
                          value: _address,
                          onTap: () {
                            // TODO: Mở dialog/trang mới để sửa địa chỉ
                          },
                        ),
                        const Divider(height: 1),
                        ProfileMenuItem(
                          icon: Icons.transgender_outlined,
                          title: 'Giới tính',
                          value: _gender,
                          onTap: () {
                            // TODO: Mở dialog/trang mới để sửa giới tính
                          },
                        ),
                      ],
                    ),
                  ),

                  vSpaceL,

                  // Phần đăng xuất
                  Card(
                    child: ProfileMenuItem(
                      icon: Icons.logout,
                      title: 'Đăng xuất',
                      onTap: () {
                        context.read<HomeCubit>().logout();
                      },
                      isEditable: false, // Ẩn mũi tên
                    ),
                  ),
                ],
              ),
            );
          }
          // Trạng thái loading ban đầu
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}