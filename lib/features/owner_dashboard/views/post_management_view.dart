import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/core/constants/colors.dart';
import 'package:mumiappfood/core/widgets/app_snackbar.dart';
import 'package:mumiappfood/core/widgets/empty_state_widget.dart';
import 'package:mumiappfood/features/owner_dashboard/state/post_management_cubit.dart';
import 'package:mumiappfood/features/owner_dashboard/widgets/post/post_management_card.dart';
import 'package:mumiappfood/features/owner_dashboard/widgets/post_management_card_shimmer.dart';
import 'package:mumiappfood/routes/app_router.dart';

enum SortOption {
  none,
  likesDesc,
  likesAsc,
  nameAsc,
  nameDesc,
}

class PostManagementView extends StatefulWidget {
  const PostManagementView({super.key});

  @override
  State<PostManagementView> createState() => _PostManagementViewState();
}

class _PostManagementViewState extends State<PostManagementView> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();
  String _searchQuery = '';
  SortOption _currentSortOption = SortOption.none;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _searchController.addListener(() {
      if (mounted) {
        setState(() {
          _searchQuery = _searchController.text;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // SỬA LỖI: Xóa BlocProvider thừa ở đây
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      floatingActionButton: Builder(builder: (fabContext) {
        return FloatingActionButton(
          heroTag: 'add_post_fab',
          tooltip: 'Tạo bài viết mới',
          onPressed: () async {
            final result = await fabContext.pushNamed<bool>(AppRouteNames.addPost);
            if (result == true && fabContext.mounted) {
              fabContext.read<PostManagementCubit>().fetchMyPosts();
            }
          },
          child: const Icon(Icons.add),
        );
      }),
      body: Column(
        children: [
          _buildFilterAndSortControls(),
          TabBar(
            controller: _tabController,
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            tabs: const [
              Tab(text: 'Chờ duyệt'),
              Tab(text: 'Đã duyệt'),
              Tab(text: 'Bị từ chối'),
            ],
          ),
          Expanded(
            child: BlocConsumer<PostManagementCubit, PostManagementState>(
              listener: (context, state) {
                if (state is PostDeleteSuccess) {
                  AppSnackbar.showSuccess(context, 'Đã xóa bài viết "${state.deletedPostTitle}".');
                } else if (state is PostManagementError && state.isActionError) {
                  AppSnackbar.showError(context, state.message);
                }
              },
              buildWhen: (previous, current) => current is! PostDeleteSuccess,
              builder: (context, state) {
                return TabBarView(
                  controller: _tabController,
                  children: [
                    _buildPostList(state, 'pending', 'Không có bài viết nào đang chờ duyệt.'),
                    _buildPostList(state, 'approved', 'Chưa có bài viết nào được duyệt.'),
                    _buildPostList(state, 'declined', 'Không có bài viết nào bị từ chối.'),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostList(PostManagementState state, String statusFilter, String emptyMessage) {
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async => context.read<PostManagementCubit>().fetchMyPosts(),
      child: Builder(builder: (context) {
        if (state is PostManagementLoading && state.posts.isEmpty) {
          return _buildShimmerList();
        }
        if (state is PostManagementError && state.posts.isEmpty) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: EmptyStateWidget(
                icon: Icons.error_outline,
                message: 'Đã có lỗi xảy ra',
                details: state.message,
                onRetry: () => context.read<PostManagementCubit>().fetchMyPosts(),
              ),
            ),
          );
        }

        final filteredByStatus = state.posts.where((p) => (p['status'] as String?)?.toLowerCase() == statusFilter).toList();
        final filteredList = _getFinalFilteredAndSortedList(filteredByStatus);

        if (filteredList.isEmpty) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: _buildEmptyState(filteredByStatus.isNotEmpty, emptyMessage),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(kSpacingM, kSpacingM, kSpacingM, 80),
          itemCount: filteredList.length,
          separatorBuilder: (context, index) => vSpaceM,
          itemBuilder: (context, index) => PostManagementCard(post: filteredList[index]),
        );
      }),
    );
  }

   List<dynamic> _getFinalFilteredAndSortedList(List<dynamic> initialList) {
    List<dynamic> filteredList = initialList;

    if (_searchQuery.isNotEmpty) {
      filteredList = filteredList.where((p) {
        final title = (p['title'] as String? ?? '').toLowerCase();
        final query = _searchQuery.toLowerCase();
        return title.contains(query);
      }).toList();
    }

    if (_currentSortOption != SortOption.none) {
      filteredList.sort((a, b) {
        switch (_currentSortOption) {
          case SortOption.likesDesc:
             return (b['likes'] as num? ?? 0).compareTo(a['likes'] as num? ?? 0);
          case SortOption.likesAsc:
             return (a['likes'] as num? ?? 0).compareTo(b['likes'] as num? ?? 0);
          case SortOption.nameAsc:
            return (a['title'] as String? ?? '').compareTo(b['title'] as String? ?? '');
          case SortOption.nameDesc:
            return (b['title'] as String? ?? '').compareTo(a['title'] as String? ?? '');
          default: return 0;
        }
      });
    }
    return filteredList;
  }

  Widget _buildEmptyState(bool isSearchResultEmpty, String emptyMessage) {
     if (isSearchResultEmpty) {
      return const EmptyStateWidget(
        icon: Icons.search_off,
        message: 'Không tìm thấy kết quả',
        details: 'Thử một từ khóa khác hoặc xóa bộ lọc tìm kiếm.',
      );
    }
    return EmptyStateWidget(
      icon: Icons.article_outlined,
      message: emptyMessage,
    );
  }

  Widget _buildShimmerList() {
    return ListView.separated(
      padding: const EdgeInsets.all(kSpacingM),
      itemCount: 7,
      separatorBuilder: (context, index) => vSpaceM,
      itemBuilder: (context, index) => const PostManagementCardShimmer(),
    );
  }

  Widget _buildFilterAndSortControls() {
     return Padding(
      padding: const EdgeInsets.fromLTRB(kSpacingM, kSpacingS, kSpacingM, kSpacingS),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Tìm theo tiêu đề...',
                prefixIcon: const Icon(Icons.search, size: 20),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                filled: true,
                fillColor: AppColors.background.withOpacity(0.5),
              ),
            ),
          ),
          hSpaceS,
          PopupMenuButton<SortOption>(
            onSelected: (SortOption result) => setState(() => _currentSortOption = result),
            icon: Icon(Icons.sort, color: _currentSortOption != SortOption.none ? AppColors.primary : AppColors.textPrimary),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<SortOption>>[
              const PopupMenuItem<SortOption>(value: SortOption.none, child: Text('Mặc định')),
              const PopupMenuDivider(),
              const PopupMenuItem<SortOption>(value: SortOption.likesDesc, child: Text('Lượt thích: Nhiều nhất')),
              const PopupMenuItem<SortOption>(value: SortOption.likesAsc, child: Text('Lượt thích: Ít nhất')),
              const PopupMenuDivider(),
              const PopupMenuItem<SortOption>(value: SortOption.nameAsc, child: Text('Tiêu đề: A-Z')),
              const PopupMenuItem<SortOption>(value: SortOption.nameDesc, child: Text('Tiêu đề: Z-A')),
            ],
          ),
        ],
      ),
    );
  }
}
