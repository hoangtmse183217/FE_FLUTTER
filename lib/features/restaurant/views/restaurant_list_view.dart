import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mumiappfood/features/restaurant/state/restaurant_cubit.dart';
import 'package:mumiappfood/features/restaurant/state/restaurant_state.dart';
import 'package:mumiappfood/features/home/widgets/home/restaurant_card.dart'; 

class RestaurantListView extends StatefulWidget {
  const RestaurantListView({super.key});

  @override
  State<RestaurantListView> createState() => _RestaurantListViewState();
}

class _RestaurantListViewState extends State<RestaurantListView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // CẢI TIẾN: Tải dữ liệu lần đầu khi màn hình được khởi tạo
    context.read<RestaurantCubit>().fetchRestaurants(); 
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    // Chỉ gọi tải trang tiếp theo nếu không có yêu cầu nào đang được xử lý
    final cubit = context.read<RestaurantCubit>();
    if (_isBottom && cubit.state is RestaurantsLoaded && !(cubit.state as RestaurantsLoaded).isLoadingNextPage) {
      cubit.fetchNextPage();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    // Trigger khi cuộn đến 90% cuối trang
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Khám phá Nhà hàng')),
      body: BlocBuilder<RestaurantCubit, RestaurantState>(
        builder: (context, state) {
          // Trường hợp 1: Đang tải lần đầu tiên
          if (state is RestaurantInitial || (state is RestaurantLoading && state is! RestaurantsLoaded)) {
            return const Center(child: CircularProgressIndicator());
          }

          // Trường hợp 2: Có lỗi nghiêm trọng khi tải lần đầu
          if (state is RestaurantError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<RestaurantCubit>().fetchRestaurants(),
                    child: const Text('Thử lại'),
                  )
                ],
              ),
            );
          }

          // Trường hợp 3: Đã tải xong và có dữ liệu (kể cả khi đang tải trang tiếp theo)
          if (state is RestaurantsLoaded) {
            if (state.restaurants.isEmpty) {
              return const Center(child: Text('Không tìm thấy nhà hàng nào.'));
            }
            return ListView.builder(
              controller: _scrollController,
              itemCount: state.hasReachedMax ? state.restaurants.length : state.restaurants.length + 1,
              itemBuilder: (context, index) {
                // Xử lý item cuối cùng (để hiển thị loading hoặc lỗi)
                if (index >= state.restaurants.length) {
                  // Nếu có lỗi khi tải trang tiếp theo, hiển thị lỗi
                  if (state.nextPageError != null) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(state.nextPageError!, style: const TextStyle(color: Colors.red)),
                      ),
                    );
                  }
                  // Nếu đang tải trang tiếp theo, hiển thị vòng quay
                  if (state.isLoadingNextPage) {
                    return const Center(child: Padding(padding: EdgeInsets.all(16.0), child: CircularProgressIndicator()));
                  }
                  // Nếu đã hết trang, không hiển thị gì cả
                  return const SizedBox.shrink();
                }

                // Hiển thị một item nhà hàng
                final restaurant = state.restaurants[index];
                // SỬA LỖI: Truyền đối tượng `restaurant` vào constructor của `RestaurantCard`
                return RestaurantCard(restaurant: restaurant);
              },
            );
          }
          
          // Trạng thái không xác định (phòng trường hợp)
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
