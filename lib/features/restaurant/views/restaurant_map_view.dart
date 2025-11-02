import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:mumiappfood/features/home/widgets/home/restaurant_card.dart';
import 'package:mumiappfood/features/restaurant/data/models/restaurant_model.dart';
import 'package:mumiappfood/features/restaurant/state/restaurant_cubit.dart';
import 'package:mumiappfood/features/restaurant/state/restaurant_state.dart';
import 'package:mumiappfood/routes/app_router.dart';

class RestaurantMapView extends StatefulWidget {
  const RestaurantMapView({super.key});

  @override
  State<RestaurantMapView> createState() => _RestaurantMapViewState();
}

class _RestaurantMapViewState extends State<RestaurantMapView> {
  GoogleMapController? _mapController;
  final Completer<GoogleMapController> _controllerCompleter = Completer();

  final Set<Marker> _markers = {};
  Map<String, dynamic>? _selectedRestaurant;

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    try {
      final position = await Geolocator.getCurrentPosition();
      final initialCameraPosition = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 15,
      );
      _mapController?.animateCamera(CameraUpdate.newCameraPosition(initialCameraPosition));
      // Sau khi có vị trí, gọi API để lấy nhà hàng gần đó
      context.read<RestaurantCubit>().fetchNearbyRestaurants(
            lat: position.latitude,
            lng: position.longitude,
          );
    } catch (e) {
      // Nếu lỗi, vẫn gọi API với vị trí mặc định (TP.HCM)
      context.read<RestaurantCubit>().fetchNearbyRestaurants(lat: 10.7769, lng: 106.7009);
    }
  }

  void _updateMarkers(List<dynamic> restaurants) {
    final newMarkers = restaurants.map((restaurant) {
      final lat = restaurant['latitude'] as double? ?? 0.0;
      final lng = restaurant['longitude'] as double? ?? 0.0;
      final restaurantId = (restaurant['id'] ?? 0).toString();

      return Marker(
        markerId: MarkerId(restaurantId),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: restaurant['name']), // Hiển thị tên khi nhấn
        onTap: () {
          setState(() {
            _selectedRestaurant = restaurant;
          });
        },
      );
    }).toSet();

    setState(() {
      _markers.clear();
      _markers.addAll(newMarkers);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nhà hàng Gần bạn'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _determinePosition, // Sửa lại để gọi hàm refresh
          ),
        ],
      ),
      body: BlocListener<RestaurantCubit, RestaurantState>(
        listener: (context, state) {
          if (state is RestaurantsLoaded) {
            _updateMarkers(state.restaurants.map((r) => r.toMap()).toList()); // Chuyển đổi lại thành Map để tương thích
          } else if (state is RestaurantError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        child: Stack(
          children: [
            GoogleMap(
              onMapCreated: (controller) {
                 _controllerCompleter.complete(controller);
                 _mapController = controller;
              },
              initialCameraPosition: const CameraPosition(
                target: LatLng(10.7769, 106.7009), // Vị trí mặc định
                zoom: 14,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              markers: _markers,
              onTap: (_) { // Khi nhấn vào vùng trống trên bản đồ
                  setState(() {
                    _selectedRestaurant = null;
                  });
              }
            ),
            // Hiển thị Card của nhà hàng được chọn
            if (_selectedRestaurant != null)
              Positioned(
                bottom: 20,
                left: 10,
                right: 10,
                child: GestureDetector(
                   onTap: () => context.pushNamed(
                        AppRouteNames.restaurantDetails,
                        pathParameters: {'restaurantId': (_selectedRestaurant!['id'] ?? '').toString()},
                    ),
                  // SỬA LỖI: Tạo đối tượng Restaurant từ Map, sau đó truyền vào RestaurantCard
                  child: RestaurantCard(restaurant: Restaurant.fromMap(_selectedRestaurant!)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
