import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/core/widgets/app_snackbar.dart';
import 'package:mumiappfood/core/widgets/empty_state_widget.dart';
import 'package:mumiappfood/features/feedback/state/feedback_cubit.dart';
import 'package:mumiappfood/features/feedback/widgets/feedback_card_shimmer.dart';
import 'package:mumiappfood/features/feedback/widgets/review_card.dart';
import 'package:shimmer/shimmer.dart'; // THÊM DÒNG IMPORT CÒN THIẾU

class FeedbackView extends StatelessWidget {
  const FeedbackView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FeedbackCubit()..fetchInitialData(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Phản hồi & Đánh giá', style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
        ),
        body: BlocConsumer<FeedbackCubit, FeedbackState>(
          listener: (context, state) {
            if (state is FeedbackError && (state.isActionError ?? false)) {
              AppSnackbar.showError(context, state.message);
            }
          },
          builder: (context, state) {
            // Trạng thái tải ban đầu (chưa có nhà hàng nào)
            if (state is FeedbackLoading && state.restaurants.isEmpty) {
              return _buildFullPageShimmer();
            }

            // Trạng thái lỗi khi chưa có dữ liệu gì
            if (state is FeedbackError && state.restaurants.isEmpty && !(state.isActionError ?? false)) {
              return EmptyStateWidget(
                icon: Icons.error_outline,
                message: 'Không thể tải dữ liệu',
                details: state.message,
                onRetry: () => context.read<FeedbackCubit>().fetchInitialData(),
              );
            }
            
            // Trường hợp không có nhà hàng nào được duyệt
            if (state is FeedbackLoaded && state.restaurants.isEmpty) {
              return const EmptyStateWidget(
                icon: Icons.store_mall_directory_outlined,
                message: 'Không có nhà hàng phù hợp',
                details: 'Bạn cần có ít nhất một nhà hàng đã được duyệt để xem và quản lý đánh giá.',
              );
            }

            // Từ đây trở đi, chúng ta luôn có danh sách nhà hàng để hiển thị dropdown
            return Column(
              children: [
                _buildRestaurantDropdown(context, state),
                Expanded(
                  child: Builder(builder: (context) {
                    // Hiển thị shimmer khi đang tải review
                    if (state is FeedbackLoading) {
                      return _buildReviewListShimmer();
                    }
                    // Hiển thị lỗi tải review (nhưng vẫn giữ lại dropdown)
                    if (state is FeedbackError && !(state.isActionError ?? false)) {
                      return EmptyStateWidget(
                        icon: Icons.error_outline,
                        message: 'Không thể tải đánh giá',
                        details: state.message,
                        onRetry: () {
                          if (state.selectedRestaurantId != null) {
                            context.read<FeedbackCubit>().fetchReviewsForRestaurant(state.selectedRestaurantId!);
                          }
                        },
                      );
                    }
                    // Hiển thị danh sách rỗng
                    if (state.reviews.isEmpty) {
                      return const EmptyStateWidget(
                        icon: Icons.rate_review_outlined,
                        message: 'Chưa có đánh giá',
                        details: 'Nhà hàng này hiện chưa nhận được đánh giá nào từ người dùng.',
                      );
                    }
                    // Hiển thị danh sách review
                    return ListView.separated(
                      padding: const EdgeInsets.all(kSpacingM),
                      itemCount: state.reviews.length,
                      separatorBuilder: (_, __) => vSpaceM,
                      itemBuilder: (context, index) {
                        return ReviewCard(review: state.reviews[index]);
                      },
                    );
                  }),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildFullPageShimmer() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(kSpacingM, kSpacingS, kSpacingM, 0),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              height: 56, 
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        Expanded(child: _buildReviewListShimmer()),
      ],
    );
  }
  
  Widget _buildReviewListShimmer() {
    return ListView.builder(
      padding: const EdgeInsets.all(kSpacingM),
      itemCount: 4,
      itemBuilder: (context, index) => const Padding(
        padding: EdgeInsets.only(bottom: kSpacingM),
        child: FeedbackCardShimmer(),
      ),
    );
  }
  
  Widget _buildRestaurantDropdown(BuildContext context, FeedbackState state) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(kSpacingM, kSpacingS, kSpacingM, 0),
      child: DropdownButtonFormField<String>(
        value: state.selectedRestaurantId,
        decoration: InputDecoration(
          labelText: 'Chọn nhà hàng',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onChanged: state.restaurants.isEmpty || state is FeedbackLoading ? null : (value) {
          if (value != null && value != state.selectedRestaurantId) {
            context.read<FeedbackCubit>().fetchReviewsForRestaurant(value);
          }
        },
        items: state.restaurants.map((r) {
          return DropdownMenuItem<String>(
            value: r['id'].toString(),
            child: Text(r['name'] as String),
          );
        }).toList(),
      ),
    );
  }
}
