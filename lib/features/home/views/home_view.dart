import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/core/widgets/app_error_widget.dart';
import 'package:mumiappfood/features/home/state/home_cubit.dart';
import 'package:mumiappfood/features/home/state/home_state.dart';
import 'package:mumiappfood/features/home/widgets/home/restaurant_card.dart';
import 'package:mumiappfood/features/home/widgets/home/restaurant_horizontal_list.dart';
import 'package:mumiappfood/features/home/widgets/home/section_header.dart';
import 'package:mumiappfood/features/post/data/models/post_model.dart';
import 'package:mumiappfood/features/post/widgets/post_card.dart';
import 'package:mumiappfood/routes/app_router.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Cung cấp HomeCubit và gọi fetch dữ liệu ngay khi màn hình được tạo
      create: (context) => HomeCubit()..fetchAllHomeData(),
      child: Scaffold(
        // Sử dụng một BlocBuilder duy nhất để quản lý toàn bộ UI
        body: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            return RefreshIndicator(
              onRefresh: () => context.read<HomeCubit>().fetchAllHomeData(),
              child: CustomScrollView(
                slivers: [
                  _buildAppBar(context),
                  const SliverToBoxAdapter(child: _AiChatBanner()),
                  
                  // --- MỤC NHÀ HÀNG GẦN BẠN ---
                  _buildSectionHeader(context, title: 'Nhà hàng gần bạn'),
                  _buildNearbySection(context, state),

                  // --- MỤC BÀI VIẾT MỚI ---
                  _buildSectionHeader(context, title: 'Có gì mới?', onSeeAll: () => context.pushNamed(AppRouteNames.postFeed)),
                  _buildPostsSection(context, state),

                  // --- MỤC NHÀ HÀNG CHO BẠN ---
                  _buildSectionHeader(context, title: 'Nhà hàng cho bạn'),
                  _buildRecommendedSection(context, state),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  SliverAppBar _buildAppBar(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      floating: false,
      elevation: 0.5,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: const Text('Trang chủ', style: TextStyle(fontWeight: FontWeight.bold)),
      actions: [
        // SỬA LỖI: Sử dụng đúng tên route là `discover`
        IconButton(onPressed: () => context.pushNamed(AppRouteNames.discover), icon: const Icon(Icons.search, size: 28)),
        IconButton(onPressed: () => context.pushNamed(AppRouteNames.notifications), icon: const Icon(Icons.notifications_none_outlined, size: 28)),
        hSpaceS,
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context, {required String title, VoidCallback? onSeeAll}) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(kSpacingM, kSpacingL, kSpacingM, kSpacingS),
        child: SectionHeader(title: title, onSeeAll: onSeeAll),
      ),
    );
  }

  // --- CÁC SECTIONS ĐƯỢC BUILD DỰA TRÊN STATE ---

  Widget _buildNearbySection(BuildContext context, HomeState state) {
    // Trường hợp cần quyền hoặc GPS bị tắt
    if (state.locationPermissionStatus == LocationPermissionStatus.denied ||
        state.locationPermissionStatus == LocationPermissionStatus.deniedForever ||
        state.locationPermissionStatus == LocationPermissionStatus.serviceDisabled) {
      return SliverToBoxAdapter(
        child: _PermissionRequestCard(
          message: state.nearbyErrorMessage ?? 'Vui lòng cấp quyền truy cập vị trí và bật GPS để tìm nhà hàng gần bạn.',
          onPressed: () => context.read<HomeCubit>().fetchNearbyWithPermissionCheck(),
        ),
      );
    }

    // Các trường hợp khác (loading, success, failure)
    return RestaurantHorizontalList(
      status: state.nearbyStatus,
      restaurants: state.nearbyRestaurants,
      errorMessage: state.nearbyErrorMessage,
      onRetry: () => context.read<HomeCubit>().fetchNearbyWithPermissionCheck(),
    );
  }

  Widget _buildPostsSection(BuildContext context, HomeState state) {
    if (state.postsStatus == HomeSectionStatus.loading) {
      return const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator()));
    }
    if (state.postsStatus == HomeSectionStatus.failure) {
      return SliverToBoxAdapter(child: AppErrorWidget(message: state.postsErrorMessage ?? '', onRetry: () => context.read<HomeCubit>().fetchRecommendedAndPosts()));
    }
    if (state.posts.isEmpty) {
      return const SliverToBoxAdapter(child: Center(child: Padding(padding: EdgeInsets.all(16.0), child: Text('Chưa có bài viết nào.'))));
    }
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 350,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: state.posts.length,
          padding: const EdgeInsets.symmetric(horizontal: kSpacingM),
          itemBuilder: (context, index) {
            return SizedBox(width: MediaQuery.of(context).size.width * 0.8, child: PostCard(post: state.posts[index]));
          },
          separatorBuilder: (context, index) => hSpaceM,
        ),
      ),
    );
  }

  Widget _buildRecommendedSection(BuildContext context, HomeState state) {
    if (state.recommendedStatus == HomeSectionStatus.loading) {
      return const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator()));
    }
    if (state.recommendedStatus == HomeSectionStatus.failure) {
      return SliverToBoxAdapter(child: AppErrorWidget(message: state.recommendedErrorMessage ?? '', onRetry: () => context.read<HomeCubit>().fetchRecommendedAndPosts()));
    }
    if (state.recommendedRestaurants.isEmpty) {
      return const SliverToBoxAdapter(child: Center(child: Text('Không có nhà hàng nào để hiển thị.')));
    }
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(kSpacingM, 0, kSpacingM, kSpacingM),
      sliver: SliverList.separated(
        itemCount: state.recommendedRestaurants.length,
        separatorBuilder: (context, index) => vSpaceM,
        itemBuilder: (context, index) => RestaurantCard(restaurant: state.recommendedRestaurants[index]),
      ),
    );
  }
}

// --- WIDGETS HỖ TRỢ ---

class _AiChatBanner extends StatelessWidget {
  const _AiChatBanner();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(kSpacingM, kSpacingS, kSpacingM, kSpacingL),
      child: InkWell(
        onTap: () => context.pushNamed(AppRouteNames.aiChat),
        borderRadius: BorderRadius.circular(50),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: kSpacingM, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Theme.of(context).scaffoldBackgroundColor,
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 2))],
          ),
          child: Row(children: [
            const Icon(Icons.psychology_alt_outlined, color: Colors.deepPurpleAccent),
            hSpaceM,
            Expanded(child: Text('Hỏi trợ lý AI về ẩm thực...', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey.shade600))),
          ]),
        ),
      ),
    );
  }
}

class _PermissionRequestCard extends StatelessWidget {
  final String message;
  final VoidCallback onPressed;
  const _PermissionRequestCard({required this.message, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: kSpacingM),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(kSpacingL),
        child: Column(
          children: [
            const Icon(Icons.location_on_outlined, size: 40, color: Colors.grey),
            vSpaceM,
            Text(message, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w500)),
            vSpaceM,
            ElevatedButton(onPressed: onPressed, child: const Text('Bật GPS & Thử lại')),
          ],
        ),
      ),
    );
  }
}
