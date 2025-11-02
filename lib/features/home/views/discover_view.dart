import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/core/models/sort_option.dart';
import 'package:mumiappfood/core/widgets/app_error_widget.dart';
import 'package:mumiappfood/features/home/data/models/discover_filter_model.dart';
import 'package:mumiappfood/features/home/state/discover_cubit.dart';
import 'package:mumiappfood/features/home/widgets/discover/discover_shimmer.dart';
import 'package:mumiappfood/features/home/widgets/discover/filter_bottom_sheet.dart';
import 'package:mumiappfood/features/home/widgets/discover/sort_selection_widget.dart';
import 'package:mumiappfood/features/home/widgets/home/restaurant_card.dart';

class DiscoverView extends StatelessWidget {
  const DiscoverView({super.key});

  void _showFilterSheet(BuildContext context) async {
    final discoverCubit = context.read<DiscoverCubit>();
    final currentFilter = discoverCubit.state.activeFilter;

    final newFilter = await showModalBottomSheet<DiscoverFilter>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FilterBottomSheet(initialFilter: currentFilter),
    );

    if (newFilter != null) {
      discoverCubit.applyFiltersAndFetch(filter: newFilter);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DiscoverCubit()..applyFiltersAndFetch(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Khám phá', style: TextStyle(fontWeight: FontWeight.bold)),
          elevation: 0.5,
          actions: [
            BlocBuilder<DiscoverCubit, DiscoverState>(
              builder: (context, state) {
                return IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () => _showFilterSheet(context),
                );
              },
            ),
          ],
        ),
        body: BlocConsumer<DiscoverCubit, DiscoverState>(
          listener: (context, state) {},
          builder: (context, state) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: kSpacingM, vertical: kSpacingS),
                  child: TextField(
                    onChanged: context.read<DiscoverCubit>().onSearchQueryChanged,
                    decoration: InputDecoration(
                      hintText: 'Tìm kiếm nhà hàng, món ăn...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: kSpacingM),
                    ),
                  ),
                ),
                SortSelectionWidget(
                  activeSort: state.activeSort,
                  onSortChanged: (sortOption) {
                    context.read<DiscoverCubit>().applySort(sortOption);
                  },
                  disabledOptions: state.activeFilter.location == null ? const {SortOption.distance} : const {},
                ),
                const Divider(height: 1),
                Expanded(
                  child: _buildContent(context, state),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, DiscoverState state) {
    if (state.status == DiscoverStatus.loading && state.originalRestaurants.isEmpty) {
      return const DiscoverShimmer();
    }

    if (state.status == DiscoverStatus.failure) {
      return AppErrorWidget(
        message: state.errorMessage ?? 'Đã có lỗi xảy ra',
        onRetry: () => context.read<DiscoverCubit>().applyFiltersAndFetch(),
      );
    }

    if (state.displayedRestaurants.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(kSpacingXL),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.search_off, size: 80, color: Colors.grey),
              vSpaceL,
              const Text(
                'Không tìm thấy kết quả',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              vSpaceS,
              const Text(
                'Hãy thử thay đổi từ khóa hoặc bộ lọc của bạn.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              vSpaceL,
              if (state.activeFilter != const DiscoverFilter.empty())
                ElevatedButton.icon(
                  onPressed: () => context.read<DiscoverCubit>().applyFiltersAndFetch(filter: const DiscoverFilter.empty()),
                  icon: const Icon(Icons.clear_all),
                  label: const Text('Xoá bộ lọc'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    foregroundColor: Colors.black87,
                    elevation: 0,
                  ),
                )
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => context.read<DiscoverCubit>().applyFiltersAndFetch(),
      child: ListView.builder(
        itemCount: state.displayedRestaurants.length,
        itemBuilder: (context, index) {
          final restaurant = state.displayedRestaurants[index];
          return RestaurantCard(restaurant: restaurant);
        },
      ),
    );
  }
}
