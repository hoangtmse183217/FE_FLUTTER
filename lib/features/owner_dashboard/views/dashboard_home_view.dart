import 'package:flutter/material.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';

import '../widgets/dashboard/summary_card.dart';

class DashboardHomeView extends StatelessWidget {
  const DashboardHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(kSpacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tổng quan',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            vSpaceM,
            // GridView cho các thẻ tóm tắt
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: kSpacingM,
              crossAxisSpacing: kSpacingM,
              childAspectRatio: 1.1,
              children: const [
                SummaryCard(
                  title: 'Nhà hàng',
                  value: '2',
                  icon: Icons.store_outlined,
                  color: Colors.blue,
                ),
                SummaryCard(
                  title: 'Đánh giá mới',
                  value: '3',
                  icon: Icons.reviews_outlined,
                  color: Colors.orange,
                ),
                SummaryCard(
                  title: 'Lượt xem',
                  value: '1.2K',
                  icon: Icons.visibility_outlined,
                  color: Colors.green,
                ),
                SummaryCard(
                  title: 'Yêu thích',
                  value: '89',
                  icon: Icons.favorite_border,
                  color: Colors.red,
                ),
              ],
            ),
            vSpaceL,
            // TODO: Thêm các biểu đồ hoặc danh sách hoạt động gần đây
          ],
        ),
      ),
    );
  }
}