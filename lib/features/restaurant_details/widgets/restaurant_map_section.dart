import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:mumiappfood/core/constants/app_spacing.dart';

class RestaurantMapSection extends StatelessWidget {
  final double latitude;
  final double longitude;
  final String restaurantName;

  const RestaurantMapSection({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.restaurantName,
  });

  @override
  Widget build(BuildContext context) {
    // final LatLng initialPosition = LatLng(latitude, longitude);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSpacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Vị trí trên bản đồ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          vSpaceM,
          // SizedBox(
          //   height: 200,
          //   width: double.infinity,
          //   child: ClipRRect(
          //     borderRadius: BorderRadius.circular(16),
          //     child: GoogleMap(
          //       initialCameraPosition: CameraPosition(
          //         target: initialPosition,
          //         zoom: 15,
          //       ),
          //       markers: {
          //         Marker(
          //           markerId: MarkerId(restaurantName),
          //           position: initialPosition,
          //           infoWindow: InfoWindow(title: restaurantName),
          //         ),
          //       },
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}