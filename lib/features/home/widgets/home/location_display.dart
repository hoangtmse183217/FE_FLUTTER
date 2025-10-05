import 'package:flutter/material.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';

class LocationDisplay extends StatelessWidget {
  // 1. Khai báo các tham số mà widget này sẽ nhận vào
  final String location;
  final VoidCallback onTap;

  const LocationDisplay({
    super.key,
    required this.location, // Bắt buộc phải có vị trí
    required this.onTap,      // Bắt buộc phải có hành động khi nhấn
  });

  @override
  Widget build(BuildContext context) {
    // InkWell để tạo hiệu ứng gợn sóng và cho phép nhấn vào
    return InkWell(
      // 2. Sử dụng callback 'onTap' được truyền từ widget cha
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.0), // Bo tròn cho hiệu ứng đẹp hơn
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        child: Row(
          mainAxisSize: MainAxisSize.min, // Giữ cho Row có chiều rộng tối thiểu
          children: [
            // Icon vị trí
            Icon(
              Icons.location_on,
              color: Theme.of(context).primaryColor,
              size: 20,
            ),
            hSpaceS,
            // Cụm văn bản hiển thị địa chỉ
            Flexible( // Dùng Flexible để văn bản không bị tràn nếu quá dài
              child: Text(
                // 3. SỬA LỖI Ở ĐÂY: Hiển thị biến 'location' thay vì một chuỗi tĩnh
                location,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis, // Thêm dấu ... nếu văn bản dài
              ),
            ),
            hSpaceXS,
            // Icon mũi tên đi xuống
            Icon(
              Icons.keyboard_arrow_down_outlined,
              color: Colors.grey[700],
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}