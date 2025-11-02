import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mumiappfood/features/restaurant/state/restaurant_cubit.dart';
import 'package:mumiappfood/features/restaurant/views/restaurant_map_view.dart';

class RestaurantMapPage extends StatelessWidget {
  const RestaurantMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Tạo một instance mới của RestaurantCubit
      create: (context) => RestaurantCubit(),
      child: const RestaurantMapView(),
    );
  }
}
