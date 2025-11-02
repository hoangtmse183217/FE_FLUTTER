import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';

class RestaurantInfoSection extends StatelessWidget {
  final String description;
  final String address;
  final double priceRange;

  const RestaurantInfoSection({
    super.key,
    required this.description,
    required this.address,
    required this.priceRange,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(kSpacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Giới thiệu', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          vSpaceS,
          Text(
            description.isNotEmpty ? description : 'Chưa có thông tin giới thiệu về nhà hàng này.',
            style: TextStyle(color: Colors.grey[700], height: 1.5),
          ),
          const Divider(height: kSpacingXL),
          _buildInfoRow(context, icon: Icons.location_on_outlined, text: address),
          
          if (priceRange > 0) ...[
            vSpaceM,
            _buildInfoRow(
              context,
              icon: Icons.attach_money_outlined,
              text: 'Khoảng ${NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ').format(priceRange)}/người',
            ),
          ],
        ],
      ), 
    );
  }

  Widget _buildInfoRow(BuildContext context, {required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).primaryColor, size: 20),
        hSpaceM,
        Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
      ],
    );
  }
}
