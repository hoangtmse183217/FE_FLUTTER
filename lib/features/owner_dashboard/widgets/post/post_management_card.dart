import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mumiappfood/routes/app_router.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostManagementCard extends StatelessWidget {
  final Map<String, dynamic> post;

  const PostManagementCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final status = post['status'];
    final bool isPending = status == 'PENDING';
    final Color statusColor = isPending ? Colors.orange : (status == 'APPROVED' ? Colors.green : Colors.red);
    final String statusText = isPending ? 'Chờ duyệt' : (status == 'APPROVED' ? 'Đã duyệt' : 'Bị từ chối');
    timeago.setLocaleMessages('vi', timeago.ViMessages());

    return Card(
      child: ListTile(
        title: Text(post['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nhà hàng: ${post['restaurantName']}'),
            const SizedBox(height: 4),
            Text(
              'Đăng ${timeago.format(post['createdAt'], locale: 'vi')}',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(statusText, style: TextStyle(color: statusColor, fontWeight: FontWeight.w600, fontSize: 12)),
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') {
              context.pushNamed(AppRouteNames.editPost, pathParameters: {'postId': post['id']});
            } else if (value == 'delete') {
              // TODO: Xử lý xóa
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'edit', child: Text('Sửa')),
            const PopupMenuItem(value: 'delete', child: Text('Xóa', style: TextStyle(color: Colors.red))),
          ],
        ),
      ),
    );
  }
}