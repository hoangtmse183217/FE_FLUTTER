import 'package:flutter/material.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/core/widgets/app_button.dart';
import 'package:mumiappfood/core/widgets/app_textfield.dart';

class AddEditPostPage extends StatefulWidget {
  final String? postId;
  const AddEditPostPage({super.key, this.postId});
  bool get isEditMode => postId != null;

  @override
  State<AddEditPostPage> createState() => _AddEditPostPageState();
}

class _AddEditPostPageState extends State<AddEditPostPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  // Dữ liệu giả, sẽ lấy từ Cubit
  String? _selectedRestaurantId;
  final List<Map<String, String>> _myRestaurants = [
    {'id': 'my-restaurant-1', 'name': 'Nhà hàng Bếp Việt của tôi'},
    {'id': 'my-restaurant-2', 'name': 'Quán Cà Phê Chờ Duyệt'},
  ];
  Set<String> _selectedMoods = {};
  final List<String> _allMoods = ['Lãng mạn', 'Sôi động', 'Thư giãn', 'Gia đình'];

  @override
  void initState() {
    super.initState();
    if (widget.isEditMode) {
      // TODO: Tải dữ liệu bài viết cũ
    }
  }

  void _savePost() {
    if (_formKey.currentState!.validate()) {
      // TODO: Gọi Cubit để lưu bài viết
      print('Lưu bài viết...');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditMode ? 'Sửa bài viết' : 'Tạo bài viết mới'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(kSpacingL),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // TODO: Thêm nút chọn ảnh bìa
              AppTextField(controller: _titleController, labelText: 'Tiêu đề', hintText: 'Nhập tiêu đề hấp dẫn'),
              vSpaceM,
              AppTextField(controller: _contentController, labelText: 'Nội dung', hintText: 'Chia sẻ câu chuyện của bạn', maxLines: 8),
              vSpaceL,
              // Chọn nhà hàng
              DropdownButtonFormField<String>(
                value: _selectedRestaurantId,
                decoration: const InputDecoration(labelText: 'Chọn nhà hàng', border: OutlineInputBorder()),
                items: _myRestaurants.map((restaurant) {
                  return DropdownMenuItem(value: restaurant['id'], child: Text(restaurant['name']!));
                }).toList(),
                onChanged: (value) {
                  setState(() { _selectedRestaurantId = value; });
                },
                validator: (value) => value == null ? 'Vui lòng chọn nhà hàng' : null,
              ),
              vSpaceL,
              // Gắn Mood
              const Text('Gắn thẻ Tâm trạng', style: TextStyle(fontWeight: FontWeight.bold)),
              vSpaceS,
              Wrap(
                spacing: kSpacingS,
                children: _allMoods.map((mood) {
                  return FilterChip(
                    label: Text(mood),
                    selected: _selectedMoods.contains(mood),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedMoods.add(mood);
                        } else {
                          _selectedMoods.remove(mood);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              vSpaceXL,
              AppButton(text: 'Đăng bài viết', onPressed: _savePost),
            ],
          ),
        ),
      ),
    );
  }
}