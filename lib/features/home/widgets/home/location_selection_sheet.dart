import 'package:flutter/material.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';

class LocationSelectionSheet extends StatelessWidget {
  // Nhận vào địa chỉ hiện tại và một hàm callback
  final String? currentAddress;
  final Future<void> Function() onRefreshLocation;

  const LocationSelectionSheet({
    super.key,
    this.currentAddress,
    required this.onRefreshLocation,
  });

  @override
  Widget build(BuildContext context) {
    // Đây là một widget `build-only`, không cần StatefulWidget nữa
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text('Chọn vị trí của bạn', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          vSpaceM,
          if (currentAddress != null && currentAddress!.isNotEmpty)
            Card(
              elevation: 0,
              color: Colors.grey[200],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              child: ListTile(
                dense: true,
                leading: Icon(Icons.my_location, color: Theme.of(context).primaryColor),
                title: const Text('Vị trí hiện tại của bạn', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(currentAddress!, style: TextStyle(color: Colors.grey[700])),
              ),
            ),
          vSpaceM,
          // Sử dụng FutureBuilder để hiển thị trạng thái loading khi nhấn "Cập nhật"
          FutureBuilder(
            future: null, // Sẽ được kích hoạt bởi onTap
            builder: (context, snapshot) {
              final isLoading = snapshot.connectionState == ConnectionState.waiting;
              return ListTile(
                leading: isLoading
                    ? SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                    : Icon(Icons.replay, color: Theme.of(context).primaryColor),
                title: Text(isLoading ? 'Đang cập nhật...' : 'Cập nhật lại vị trí'),
                onTap: isLoading ? null : () async {
                  // Gọi hàm callback từ HomeView và đóng sheet sau khi xong
                  await onRefreshLocation();
                  if (context.mounted) Navigator.pop(context);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}