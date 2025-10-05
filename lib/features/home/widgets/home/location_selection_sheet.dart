import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:mumiappfood/core/widgets/app_snackbar.dart';
import 'package:mumiappfood/routes/app_router.dart';

// 1. Chuyển widget thành StatefulWidget để có thể quản lý trạng thái
class LocationSelectionSheet extends StatefulWidget {
  const LocationSelectionSheet({super.key});

  @override
  State<LocationSelectionSheet> createState() => _LocationSelectionSheetState();
}

class _LocationSelectionSheetState extends State<LocationSelectionSheet> {
  // 2. Tạo một biến cờ để theo dõi trạng thái đang xử lý
  bool _isProcessing = false;
  String? _currentAddress;

  // Hàm xử lý logic lấy vị trí GPS
  Future<void> _getCurrentLocation() async {
    // 3. Nếu đang xử lý, không làm gì cả
    if (_isProcessing) return;

    // 4. Đặt cờ thành true để chặn các lần nhấn tiếp theo
    setState(() {
      _isProcessing = true;
    });

    try {
      // --- Phần logic lấy vị trí giữ nguyên ---
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        AppSnackbar.showError(context, 'Vui lòng bật dịch vụ định vị.');
        _resetProcessingState(); // Nhớ reset cờ
        return;
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        AppSnackbar.showError(context, 'Vui lòng cấp quyền truy cập vị trí.');
        _resetProcessingState();
        return;
      }

      Position position = await Geolocator.getCurrentPosition();

      if (!context.mounted) return;

      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

      if (!context.mounted) return;

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String address = "${place.subAdministrativeArea}, ${place.administrativeArea}";
        Navigator.pop(context, address);
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        AppSnackbar.showError(context, 'Không thể lấy được vị trí.');
      }
    } finally {
      // 5. Dù thành công hay thất bại, luôn reset cờ sau khi xử lý xong
      _resetProcessingState();
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchCurrentAddress();
  }

  Future<void> _fetchCurrentAddress() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) return;

      Position position = await Geolocator.getCurrentPosition();
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty && mounted) {
        Placemark place = placemarks[0];
        String address = [
          if (place.street != null && place.street!.isNotEmpty) place.street,
          if (place.subLocality != null && place.subLocality!.isNotEmpty) place.subLocality,
          if (place.subAdministrativeArea != null && place.subAdministrativeArea!.isNotEmpty) place.subAdministrativeArea,
          if (place.administrativeArea != null && place.administrativeArea!.isNotEmpty) place.administrativeArea,
          if (place.country != null && place.country!.isNotEmpty) place.country,
        ].join(', ');
        setState(() {
          _currentAddress = address;
        });
      }
    } catch (_) {
      // ignore error, don't show address
    }
  }

  // Hàm helper để reset trạng thái
  void _resetProcessingState() {
    if (mounted) {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text('Chọn vị trí của bạn', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          if (_currentAddress != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.location_on, color: Theme.of(context).primaryColor, size: 20),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    _currentAddress!,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
          const SizedBox(height: 12),
          ListTile(
            leading: Icon(
              // Thay đổi icon để thể hiện trạng thái loading
                _isProcessing ? Icons.hourglass_top : Icons.my_location,
                color: Theme.of(context).primaryColor
            ),
            title: Text(_isProcessing ? 'Đang lấy vị trí...' : 'Sử dụng vị trí hiện tại'),
            subtitle: const Text('Gợi ý nhà hàng gần bạn nhất'),
            // 6. Gọi hàm đã được bảo vệ
            onTap: _getCurrentLocation,
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.edit_location_alt_outlined, color: Theme.of(context).primaryColor),
            title: const Text('Tự nhập địa chỉ'),
            subtitle: const Text('Tìm kiếm ở một khu vực khác'),
            onTap: _isProcessing ? null : () {
              Navigator.pop(context);
              Future.microtask(() => GoRouter.of(context).push('/address-input'));
            },
          ),
        ],
      ),
    );
  }
}