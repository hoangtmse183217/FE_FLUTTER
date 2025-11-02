import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mumiappfood/features/home/data/repositories/home_repository.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository _repository;

  HomeCubit({HomeRepository? repository})
      : _repository = repository ?? HomeRepository(),
        super(const HomeState());

  /// Phương thức tổng hợp để tải tất cả dữ liệu cho màn hình chính
  Future<void> fetchAllHomeData() async {
    // Chạy song song việc lấy vị trí và các dữ liệu khác
    await Future.wait([
      fetchNearbyWithPermissionCheck(),
      fetchRecommendedAndPosts(),
    ]);
  }

  /// Lấy dữ liệu cho 2 mục: Bài viết mới và Nhà hàng cho bạn
  Future<void> fetchRecommendedAndPosts() async {
    emit(state.copyWith(
      postsStatus: HomeSectionStatus.loading,
      recommendedStatus: HomeSectionStatus.loading,
    ));
    try {
      final data = await _repository.getHomeData();
      emit(state.copyWith(
        postsStatus: HomeSectionStatus.success,
        recommendedStatus: HomeSectionStatus.success,
        posts: data['posts'],
        recommendedRestaurants: data['restaurants'],
        moods: data['moods'],
      ));
    } catch (e) {
      emit(state.copyWith(
        postsStatus: HomeSectionStatus.failure,
        postsErrorMessage: e.toString(),
        recommendedStatus: HomeSectionStatus.failure,
        recommendedErrorMessage: e.toString(),
      ));
    }
  }

  /// Xử lý toàn bộ logic cho mục "Nhà hàng gần bạn"
  Future<void> fetchNearbyWithPermissionCheck() async {
    emit(state.copyWith(nearbyStatus: HomeSectionStatus.loading));

    try {
      // 1. Kiểm tra quyền truy cập vị trí
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          emit(state.copyWith(
            nearbyStatus: HomeSectionStatus.failure,
            locationPermissionStatus: LocationPermissionStatus.denied,
            nearbyErrorMessage: 'Người dùng đã từ chối quyền truy cập vị trí.',
          ));
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        emit(state.copyWith(
          nearbyStatus: HomeSectionStatus.failure,
          locationPermissionStatus: LocationPermissionStatus.deniedForever,
          nearbyErrorMessage: 'Quyền truy cập vị trí đã bị từ chối vĩnh viễn.',
        ));
        return;
      }

      // 2. Kiểm tra xem dịch vụ vị trí có được bật không
      final isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!isLocationServiceEnabled) {
        emit(state.copyWith(
          nearbyStatus: HomeSectionStatus.failure,
          locationPermissionStatus: LocationPermissionStatus.serviceDisabled,
          nearbyErrorMessage: 'Vui lòng bật dịch vụ định vị (GPS) trên thiết bị của bạn.',
        ));
        return;
      }

      // 3. Nếu mọi thứ OK, lấy vị trí hiện tại
      emit(state.copyWith(locationPermissionStatus: LocationPermissionStatus.granted));
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // 4. Gọi Repository để lấy danh sách nhà hàng
      final restaurants = await _repository.getNearbyRestaurants(position.latitude, position.longitude);

      emit(state.copyWith(
        nearbyStatus: HomeSectionStatus.success,
        nearbyRestaurants: restaurants,
      ));
    } catch (e) {
      emit(state.copyWith(
        nearbyStatus: HomeSectionStatus.failure,
        nearbyErrorMessage: e.toString(),
      ));
    }
  }
}
