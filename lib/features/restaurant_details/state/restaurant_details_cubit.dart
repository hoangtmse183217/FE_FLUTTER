import 'package:bloc/bloc.dart';
import 'package:mumiappfood/features/post/data/models/post_model.dart';
import 'package:mumiappfood/features/post/data/repositories/post_repository.dart';
import 'package:mumiappfood/features/restaurant/data/models/restaurant_model.dart';
import 'package:mumiappfood/features/restaurant/data/repositories/restaurant_repository.dart';
import 'restaurant_details_state.dart';

class RestaurantDetailsCubit extends Cubit<RestaurantDetailsState> {
  final RestaurantRepository _restaurantRepository;
  final PostRepository _postRepository;

  RestaurantDetailsCubit({
    RestaurantRepository? restaurantRepository,
    PostRepository? postRepository,
  })
      : _restaurantRepository = restaurantRepository ?? RestaurantRepository(),
        _postRepository = postRepository ?? PostRepository(),
        super(RestaurantDetailsInitial());

  Future<void> fetchRestaurantDetails(String restaurantId) async {
    if (state is RestaurantDetailsLoading) return;
    emit(RestaurantDetailsLoading());
    try {
      final id = int.tryParse(restaurantId);
      if (id == null) {
        throw const FormatException('ID của nhà hàng không hợp lệ.');
      }

      final results = await Future.wait([
        _restaurantRepository.getRestaurantDetails(id),
        _postRepository.getPostsByRestaurant(restaurantId: id, page: 1, pageSize: 10),
      ]);

      final restaurant = results[0] as Restaurant;
      final posts = (results[1] as Map<String, dynamic>)['items'] as List<Post>;

      emit(RestaurantDetailsLoaded(restaurant: restaurant, posts: posts));
    } catch (e) {
      emit(RestaurantDetailsError(message: e.toString()));
    }
  }
}
