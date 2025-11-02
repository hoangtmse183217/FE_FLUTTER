import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:url_launcher/url_launcher.dart';

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

  // SỬA LỖI: Thêm phương thức để mở ứng dụng bản đồ bên ngoài
  Future<void> _launchMapsUrl(BuildContext context) async {
    final Uri url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        // TODO: Use AppLocalizations and AppSnackbar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không thể mở ứng dụng bản đồ.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final LatLng initialPosition = LatLng(latitude, longitude);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSpacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TODO: Use AppLocalizations
          const Text('Vị trí trên bản đồ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          vSpaceM,
          Stack(
            children: [
              SizedBox(
                height: 200,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: GoogleMap(
                    scrollGesturesEnabled: false,
                    zoomGesturesEnabled: false,
                    initialCameraPosition: CameraPosition(
                      target: initialPosition,
                      zoom: 15,
                    ),
                    markers: {
                      Marker(
                        markerId: MarkerId(restaurantName),
                        position: initialPosition,
                        infoWindow: InfoWindow(title: restaurantName),
                      ),
                    },
                  ),
                ),
              ),
              // SỬA LỖI: Thêm nút để mở bản đồ trong ứng dụng ngoài
              Positioned(
                top: kSpacingS,
                right: kSpacingS,
                child: FloatingActionButton.small(
                  heroTag: 'open-maps-fab', // Tránh lỗi trùng tag nếu có nhiều FAB
                  onPressed: () => _launchMapsUrl(context),
                  backgroundColor: Colors.white,
                  child: Icon(Icons.open_in_new, color: Theme.of(context).primaryColor),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
