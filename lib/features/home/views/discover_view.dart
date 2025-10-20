import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/features/home/state/discover_cubit.dart';
import 'package:mumiappfood/features/home/widgets/discover/mood_filter_chip.dart';
import 'package:mumiappfood/features/home/widgets/discover/home_search_bar.dart';
import 'package:mumiappfood/features/home/widgets/home/restaurant_card.dart';

import '../../../core/constants/colors.dart';
import '../../../l10n/app_localizations.dart';
import '../widgets/discover/filter_bottom_sheet.dart';

class DiscoverView extends StatelessWidget {
  const DiscoverView({super.key});

  void _showFilterSheet(BuildContext context, DiscoverLoaded currentState) async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return FilterBottomSheet(
          initialPriceRanges: currentState.selectedPriceRanges,
          initialMinRating: currentState.minRating,
        );
      },
    );

    if (result != null && context.mounted) {
      context.read<DiscoverCubit>().applyFilters(
        priceRanges: result['priceRanges'] as Set<String>,
        rating: result['minRating'] as double,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (context) => DiscoverCubit()..fetchInitialData(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(localizations.discover),
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
        body: BlocBuilder<DiscoverCubit, DiscoverState>(
          builder: (context, state) {
            if (state is DiscoverLoading || state is DiscoverInitial) {
              return const Center(child: CircularProgressIndicator(color: AppColors.primary));
            }

            if (state is DiscoverError) {
              return Center(child: Text(state.message));
            }

            if (state is DiscoverLoaded) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: kSpacingM),
                    child: HomeSearchBar(
                      onFilterTap: () => _showFilterSheet(context, state),
                    ),
                  ),
                  vSpaceL,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: kSpacingM),
                    child: Text(
                      localizations.whatsYourMood,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  vSpaceS,
                  SizedBox(
                    height: 50,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: kSpacingM),
                      children: state.allMoods.map((moodKey) { // Now expecting keys
                        return Padding(
                          padding: const EdgeInsets.only(right: kSpacingS),
                          child: MoodFilterChip(
                            mood: moodKey, // Pass the key
                            isSelected: state.selectedMoods.contains(moodKey),
                            onSelected: (selectedMoodKey) {
                              context.read<DiscoverCubit>().filterByMood(selectedMoodKey);
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const Divider(height: kSpacingL),
                  Expanded(
                    child: Stack(
                      children: [
                        if (state.restaurants.isEmpty && !state.isLoading)
                          Center(
                            child: Text(localizations.noRestaurantsFound),
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
                              cuisine: localizations.diverseCuisine,
                              rating: 4.5, // Dữ liệu giả
                              moods: List<String>.from(restaurant['moods']), // Assuming these are keys now
                            );
                          },
                        ),
                        if (state.isLoading)
                          Container(
                            color: Colors.black.withOpacity(0.1),
                            child: const Center(child: CircularProgressIndicator(color: AppColors.primary)),
                          ),
                      ],
                    ),
                  ),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
