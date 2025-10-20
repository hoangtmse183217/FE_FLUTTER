import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mumiappfood/features/home/state/favorites_cubit.dart';
import 'package:mumiappfood/features/home/widgets/favorites/empty_favorites.dart';
import 'package:mumiappfood/features/home/widgets/favorites/favorite_restaurant_list.dart';

import '../../../l10n/app_localizations.dart';

class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.favoriteRestaurants),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, state) {
          if (state is FavoritesLoading || state is FavoritesInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is FavoritesError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('${localizations.errorOccurred}${state.message}'),
              ),
            );
          }

          if (state is FavoritesLoaded) {
            if (state.favoriteRestaurants.isEmpty) {
              return const EmptyFavorites();
            }

            return FavoriteRestaurantList(
              favoriteRestaurants: state.favoriteRestaurants,
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
