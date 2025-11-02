import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mumiappfood/features/favorites/state/favorites_cubit.dart';
import 'package:mumiappfood/features/restaurant/state/restaurant_cubit.dart';
import 'package:mumiappfood/features/restaurant/views/restaurant_list_view.dart';

class RestaurantListPage extends StatelessWidget {
  const RestaurantListPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Cung cấp cả 2 cubit cần thiết cho màn hình
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => RestaurantCubit()..fetchRestaurants(),
        ),
        // RestaurantCard cần FavoritesCubit để hiển thị nút trái tim
        BlocProvider.value(
          value: BlocProvider.of<FavoritesCubit>(context),
        ),
      ],
      child: const RestaurantListView(),
    );
  }
}
