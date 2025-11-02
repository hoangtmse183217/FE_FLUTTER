import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/core/constants/colors.dart';
import 'package:mumiappfood/core/widgets/empty_state_widget.dart';
import 'package:mumiappfood/features/owner_dashboard/state/owner_dashboard_cubit.dart';
import 'package:mumiappfood/features/owner_dashboard/widgets/restaurant_management_card.dart';
import 'package:mumiappfood/features/owner_dashboard/widgets/restaurant_management_card_shimmer.dart';
import '../../../routes/app_router.dart';

enum SortOption {
  none,
  ratingDesc,
  ratingAsc,
  nameAsc,
  nameDesc,
}

class RestaurantManagementView extends StatefulWidget {
  const RestaurantManagementView({super.key});

  @override
  State<RestaurantManagementView> createState() => _RestaurantManagementViewState();
}

class _RestaurantManagementViewState extends State<RestaurantManagementView> with SingleTickerProviderStateMixin {
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
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      floatingActionButton: FloatingActionButton(
        heroTag: 'add_restaurant_fab',
        onPressed: () async {
          final result = await context.pushNamed<bool>(AppRouteNames.addRestaurant);
          if (result == true && context.mounted) {
            context.read<OwnerDashboardCubit>().refreshRestaurants();
          }
        },
        tooltip: 'Thêm nhà hàng mới',
        child: const Icon(Icons.add),
      ),
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
              Tab(text: 'Từ chối'),
            ],
          ),
          Expanded(
            child: BlocBuilder<OwnerDashboardCubit, OwnerDashboardState>(
              builder: (context, state) {
                return TabBarView(
                  controller: _tabController,
                  children: [
                    _buildRestaurantList(state, 'pending', 'Chưa có nhà hàng nào đang chờ duyệt.', 'Hãy kiên nhẫn, chúng tôi sẽ sớm xem xét nhà hàng của bạn.'),
                    _buildRestaurantList(state, 'approved', 'Chưa có nhà hàng nào được duyệt.', 'Các nhà hàng đã duyệt sẽ xuất hiện ở đây.'),
                    _buildRestaurantList(state, 'declined', 'Không có nhà hàng nào bị từ chối.', null),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRestaurantList(OwnerDashboardState state, String statusFilter, String emptyMessage, String? emptyDetails) {
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async => context.read<OwnerDashboardCubit>().refreshRestaurants(),
      child: Builder(builder: (context) {
        if (state is OwnerDashboardLoading) {
          return _buildShimmerList();
        }
        if (state is OwnerDashboardError) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: EmptyStateWidget(
                icon: Icons.error_outline,
                message: 'Đã có lỗi xảy ra',
                details: state.message,
                onRetry: () => context.read<OwnerDashboardCubit>().refreshData(),
              ),
            ),
          );
        }
        if (state is OwnerDashboardLoaded) {
          final filteredByStatus = state.restaurants.where((r) => (r['status'] as String?)?.toLowerCase() == statusFilter).toList();
          final filteredList = _getFinalFilteredAndSortedList(filteredByStatus);

          if (filteredList.isEmpty) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: _buildEmptyState(filteredByStatus.isNotEmpty, emptyMessage, emptyDetails),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(kSpacingM, kSpacingM, kSpacingM, 80),
            itemCount: filteredList.length,
            separatorBuilder: (context, index) => vSpaceM,
            itemBuilder: (context, index) => RestaurantManagementCard(restaurant: filteredList[index]),
          );
        }
        return const SizedBox.shrink();
      }),
    );
  }

  List<dynamic> _getFinalFilteredAndSortedList(List<dynamic> initialList) {
    List<dynamic> filteredList = initialList;

    if (_searchQuery.isNotEmpty) {
      filteredList = filteredList.where((r) {
        final name = (r['name'] as String? ?? '').toLowerCase();
        final address = (r['address'] as String? ?? '').toLowerCase();
        final query = _searchQuery.toLowerCase();
        return name.contains(query) || address.contains(query);
      }).toList();
    }

    if (_currentSortOption != SortOption.none) {
      filteredList.sort((a, b) {
        switch (_currentSortOption) {
          case SortOption.ratingDesc:
            return ((b['rating'] as num?)?.toDouble() ?? 0.0).compareTo((a['rating'] as num?)?.toDouble() ?? 0.0);
          case SortOption.ratingAsc:
            return ((a['rating'] as num?)?.toDouble() ?? 0.0).compareTo((b['rating'] as num?)?.toDouble() ?? 0.0);
          case SortOption.nameAsc:
            return (a['name'] as String? ?? '').compareTo(b['name'] as String? ?? '');
          case SortOption.nameDesc:
            return (b['name'] as String? ?? '').compareTo(a['name'] as String? ?? '');
          default: return 0;
        }
      });
    }
    return filteredList;
  }

  Widget _buildEmptyState(bool isSearchResultEmpty, String emptyMessage, String? emptyDetails) {
     if (isSearchResultEmpty) {
      return const EmptyStateWidget(
        icon: Icons.search_off,
        message: 'Không tìm thấy kết quả',
        details: 'Thử một từ khóa khác hoặc xóa bộ lọc tìm kiếm.',
      );
    }
    return EmptyStateWidget(
      icon: Icons.storefront_outlined,
      message: emptyMessage,
      details: emptyDetails,
    );
  }

  Widget _buildShimmerList() {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(kSpacingM, kSpacingM, kSpacingM, 80),
      itemCount: 5, 
      separatorBuilder: (context, index) => vSpaceM,
      itemBuilder: (context, index) => const RestaurantManagementCardShimmer(),
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
                hintText: 'Tìm theo tên hoặc địa chỉ...',
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
              const PopupMenuItem<SortOption>(value: SortOption.ratingDesc, child: Text('Đánh giá: Cao nhất')),
              const PopupMenuItem<SortOption>(value: SortOption.ratingAsc, child: Text('Đánh giá: Thấp nhất')),
              const PopupMenuDivider(),
              const PopupMenuItem<SortOption>(value: SortOption.nameAsc, child: Text('Tên: A-Z')),
              const PopupMenuItem<SortOption>(value: SortOption.nameDesc, child: Text('Tên: Z-A')),
            ],
          ),
        ],
      ),
    );
  }
}
