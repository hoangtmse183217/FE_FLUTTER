import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/features/home/state/discover_cubit.dart';

import 'package:mumiappfood/features/home/widgets/discover/mood_filter_chip.dart';
import 'package:mumiappfood/features/home/widgets/discover/home_search_bar.dart';
import 'package:mumiappfood/features/home/widgets/home/restaurant_card.dart';

import '../widgets/discover/FilterBottomSheet.dart';

class DiscoverView extends StatelessWidget {
  const DiscoverView({super.key});

  // Tách hàm hiển thị bottom sheet ra cho gọn gàng và dễ đọc.
  void _showFilterSheet(BuildContext context, DiscoverLoaded currentState) async {
    // 1. Hiển thị BottomSheet và chờ kết quả trả về.
    // Kết quả là một Map chứa các giá trị filter người dùng đã chọn.
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true, // Cho phép bottom sheet có chiều cao linh hoạt
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        // Truyền các giá trị filter hiện tại vào BottomSheet
        return FilterBottomSheet(
          initialPriceRanges: currentState.selectedPriceRanges,
          initialMinRating: currentState.minRating,
        );
      },
    );

    // 2. Nếu người dùng nhấn "Áp dụng" (result không null), gọi Cubit để xử lý
    if (result != null && context.mounted) {
      context.read<DiscoverCubit>().applyFilters(
        priceRanges: result['priceRanges'] as Set<String>,
        rating: result['minRating'] as double,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DiscoverCubit()..fetchInitialData(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Khám phá'),
          // Bỏ elevation để liền mạch với body
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
        body: BlocBuilder<DiscoverCubit, DiscoverState>(
          builder: (context, state) {
            if (state is DiscoverLoading || state is DiscoverInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is DiscoverError) {
              return Center(child: Text(state.message));
            }

            if (state is DiscoverLoaded) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- THANH TÌM KIẾM VÀ BỘ LỌC ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: kSpacingM),
                    child: HomeSearchBar(
                      onFilterTap: () => _showFilterSheet(context, state),
                    ),
                  ),
                  vSpaceL,

                  // --- BỘ LỌC MOOD ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: kSpacingM),
                    child: Text(
                      'Tâm trạng của bạn là...',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  vSpaceS,
                  SizedBox(
                    height: 50,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: kSpacingM),
                      children: state.allMoods.map((mood) {
                        return Padding(
                          padding: const EdgeInsets.only(right: kSpacingS),
                          child: MoodFilterChip(
                            mood: mood,
                            isSelected: state.selectedMoods.contains(mood),
                            onSelected: (selectedMood) {
                              context.read<DiscoverCubit>().filterByMood(selectedMood);
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const Divider(height: kSpacingL),

                  // --- DANH SÁCH KẾT QUẢ ---
                  Expanded(
                    child: Stack(
                      children: [
                        if (state.restaurants.isEmpty && !state.isLoading)
                          const Center(
                            child: Text('Không tìm thấy nhà hàng nào phù hợp.'),
                          ),
                        ListView.separated(
                          padding: const EdgeInsets.all(kSpacingM),
                          itemCount: state.restaurants.length,
                          separatorBuilder: (context, index) => vSpaceM,
                          itemBuilder: (context, index) {
                            final restaurant = state.restaurants[index];
                            return RestaurantCard(
                              restaurantId: restaurant['id'] ?? 'unknown-id',
                              name: restaurant['name'],
                              imageUrl: 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=500',
                              cuisine: 'Ẩm thực đa dạng',
                              rating: 4.5, // Dữ liệu giả
                              moods: List<String>.from(restaurant['moods']),
                            );
                          },
                        ),
                        // Lớp phủ loading khi đang lọc
                        if (state.isLoading)
                          Container(
                            color: Colors.white.withOpacity(0.5),
                            child: const Center(child: CircularProgressIndicator()),
                          ),
                      ],
                    ),
                  ),
                ],
              );
            }

            return const SizedBox.shrink(); // Trường hợp state không xác định
          },
        ),
      ),
    );
  }
}