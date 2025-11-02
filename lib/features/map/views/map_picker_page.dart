import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mumiappfood/core/widgets/app_button.dart';
import 'package:mumiappfood/core/widgets/app_snackbar.dart';

class MapPickerPage extends StatefulWidget {
  final LatLng? initialPosition;
  const MapPickerPage({super.key, this.initialPosition});

  @override
  State<MapPickerPage> createState() => _MapPickerPageState();
}

class _MapPickerPageState extends State<MapPickerPage> {
  final _searchController = TextEditingController();
  GoogleMapController? _mapController;
  late LatLng _currentMapCenter;
  bool _isLoading = true;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialPosition != null) {
      _currentMapCenter = widget.initialPosition!;
      _isLoading = false;
    } else {
      _currentMapCenter = const LatLng(10.7769, 106.7009); // Default to HCMC
      _determinePosition();
    }
  }

  Future<void> _determinePosition() async {
    try {
      final position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentMapCenter = LatLng(position.latitude, position.longitude);
        _isLoading = false;
      });
      _mapController?.animateCamera(CameraUpdate.newLatLng(_currentMapCenter));
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _searchAndMoveToAddress() async {
    if (_searchController.text.trim().isEmpty) return;

    setState(() => _isSearching = true);

    try {
      final locations = await locationFromAddress(_searchController.text);
      if (locations.isNotEmpty) {
        final location = locations.first;
        final target = LatLng(location.latitude, location.longitude);
        _mapController?.animateCamera(CameraUpdate.newLatLngZoom(target, 17.0));
      } else {
        if (mounted) AppSnackbar.showError(context, 'Không tìm thấy địa chỉ này.');
      }
    } catch (e) {
      if (mounted) AppSnackbar.showError(context, 'Lỗi khi tìm kiếm địa chỉ. Vui lòng thử lại.');
    }

    setState(() => _isSearching = false);
  }

  void _onConfirm() async {
    // SỬA LỖI LOGIC: Trả về trực tiếp LatLng để người gọi dễ xử lý
    Navigator.pop(context, _currentMapCenter);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chọn vị trí')),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) => _mapController = controller,
            initialCameraPosition: CameraPosition(target: _currentMapCenter, zoom: 15),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            onCameraMove: (position) => _currentMapCenter = position.target,
          ),
          const Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 50),
              child: Icon(Icons.location_pin, color: Colors.red, size: 50),
            ),
          ),
          Positioned(
            top: 10,
            left: 15,
            right: 15,
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Nhập địa chỉ đầy đủ...",
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _isSearching
                      ? const Padding(padding: EdgeInsets.all(12.0), child: CircularProgressIndicator(strokeWidth: 2))
                      : IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: _searchAndMoveToAddress,
                        ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                ),
                onSubmitted: (_) => _searchAndMoveToAddress(),
              ),
            ),
          ),
          if (_isLoading)
            Container(color: Colors.white.withOpacity(0.8), child: const Center(child: CircularProgressIndicator())),
          Positioned(
            bottom: 30,
            left: 24,
            right: 24,
            child: AppButton(
                text: 'Xác nhận vị trí này',
                onPressed: _onConfirm),
          ),
        ],
      ),
    );
  }
}
