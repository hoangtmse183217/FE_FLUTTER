import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mumiappfood/core/constants/colors.dart';

class ProfileAvatar extends StatelessWidget {
  final String? photoURL;
  final String fallbackText;
  final Function(XFile) onImageSelected;
  final double radius; // Tham số mới được thêm vào

  const ProfileAvatar({
    super.key,
    this.photoURL,
    required this.fallbackText,
    required this.onImageSelected,
    this.radius = 40, // Giá trị mặc định
  });

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      onImageSelected(image);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasImage = photoURL != null && photoURL!.isNotEmpty;
    final imageProvider = hasImage
        ? (photoURL!.startsWith('http')
            ? NetworkImage(photoURL!)
            : FileImage(File(photoURL!)) as ImageProvider)
        : null;

    return Stack(
      alignment: Alignment.center,
      children: [
        CircleAvatar(
          radius: radius, // Sử dụng tham số radius
          backgroundImage: imageProvider,
          backgroundColor: AppColors.primary.withOpacity(0.1),
          child: imageProvider == null
              ? Text(
                  fallbackText,
                  style: TextStyle(
                    fontSize: radius * 0.8, // Kích thước chữ dựa trên radius
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : null,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: _pickImage,
            child: Container(
              width: radius * 0.5, // Kích thước icon dựa trên radius
              height: radius * 0.5,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(
                Icons.edit,
                color: Colors.white,
                size: 16, // Giữ kích thước icon cố định hoặc tỷ lệ
              ),
            ),
          ),
        ),
      ],
    );
  }
}
