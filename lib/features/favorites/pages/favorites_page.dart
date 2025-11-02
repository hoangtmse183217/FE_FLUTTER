import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mumiappfood/features/favorites/state/favorites_cubit.dart';
import 'package:mumiappfood/features/favorites/views/favorites_view.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      // FavoritesCubit đã được cung cấp ở tầng cao hơn (tại HomePage hoặc main)
      // nên chúng ta chỉ cần sử dụng lại nó bằng BlocProvider.value
      value: BlocProvider.of<FavoritesCubit>(context)..fetchFavorites(),
      child: const FavoritesView(),
    );
  }
}
