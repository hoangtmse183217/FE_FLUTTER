import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/core/widgets/app_snackbar.dart';
import 'package:mumiappfood/features/owner_dashboard/state/restaurant_images_cubit.dart';

class RestaurantImagesPage extends StatelessWidget {
  final String restaurantId;

  const RestaurantImagesPage({super.key, required this.restaurantId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RestaurantImagesCubit(restaurantId: restaurantId)..fetchImages(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Quản lý Ảnh'),
        ),
        body: BlocConsumer<RestaurantImagesCubit, RestaurantImagesState>(
          listener: (context, state) {
            if (state is RestaurantImagesError) {
              // Hiển thị SnackBar lỗi mà không build lại cả trang
              // nhưng chỉ khi lỗi đó không phải là lỗi tạm thời khi hoàn tác
              if (context.read<RestaurantImagesCubit>().state is! RestaurantImagesLoaded) {
                AppSnackbar.showError(context, state.message);
              }
            }
          },
          buildWhen: (previous, current) => current is! RestaurantImagesError, // Không build lại UI khi có lỗi
          builder: (context, state) {
            if (state is RestaurantImagesLoading || state is RestaurantImagesInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is RestaurantImagesLoaded) {
              return GridView.builder(
                padding: const EdgeInsets.all(kSpacingM),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: kSpacingM,
                  mainAxisSpacing: kSpacingM,
                ),
                // --- SỬA LỖI 1 ---
                itemCount: state.imagesData.length + 1, // Dùng 'imagesData'
                itemBuilder: (context, index) {
                  // Nút "Thêm ảnh"
                  if (index == 0) {
                    return InkWell(
                      onTap: state.isUploading
                          ? null
                          : () => context.read<RestaurantImagesCubit>().pickAndUploadImage(),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[400]!),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: state.isUploading
                              ? const CircularProgressIndicator()
                              : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_a_photo_outlined, size: 40, color: Colors.grey[600]),
                              vSpaceS,
                              Text('Tải ảnh lên', style: TextStyle(color: Colors.grey[600])),
                            ],
                          ),
                        ),
                      ),
                    );
                  }

                  // Các ảnh hiện có
                  // --- SỬA LỖI 1 ---
                  final image = state.imagesData[index - 1]; // Dùng 'imagesData'
                  final imageUrl = image['imageUrl'] as String;
                  final imageId = image['id'] as String; // Lấy ID của ảnh

                  return ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(imageUrl, fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(color: Colors.grey[200])),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: CircleAvatar(
                            backgroundColor: Colors.black.withOpacity(0.6),
                            radius: 16,
                            child: IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.white, size: 16),
                              onPressed: () {
                                // --- SỬA LỖI 2 ---
                                // Truyền 'imageId' (là String) vào hàm deleteImage
                                context.read<RestaurantImagesCubit>().deleteImage(imageId);
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              );
            }
            // Fallback cho các state không xác định hoặc lỗi đã được listener xử lý
            return const Center(child: Text('Đã có lỗi xảy ra.'));
          },
        ),
      ),
    );
  }
}