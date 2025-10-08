import 'package:flutter/material.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/core/utils/validator_utils.dart';
import 'package:mumiappfood/core/widgets/app_button.dart';
import 'package:mumiappfood/core/widgets/app_textfield.dart';

import '../../../core/constants/colors.dart';

class AddEditRestaurantPage extends StatefulWidget {
  final String? restaurantId; // null nếu là "Thêm mới", có giá trị nếu là "Sửa"

  const AddEditRestaurantPage({super.key, this.restaurantId});

  bool get isEditMode => restaurantId != null;

  @override
  State<AddEditRestaurantPage> createState() => _AddEditRestaurantPageState();
}

class _AddEditRestaurantPageState extends State<AddEditRestaurantPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceRangeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.isEditMode) {
      _loadRestaurantData();
    }
  }

  void _loadRestaurantData() {
    // TODO: Gọi Cubit để lấy dữ liệu chi tiết của nhà hàng
    print('Đang ở chế độ Sửa cho nhà hàng ID: ${widget.restaurantId}');
  }

  void _saveRestaurant() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      // TODO: Gọi Cubit để lưu dữ liệu
      print('Lưu nhà hàng...');
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _descriptionController.dispose();
    _priceRangeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.isEditMode;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 1,
        backgroundColor: AppColors.surface,
        centerTitle: false,
        title: Text(
          isEdit ? 'Sửa thông tin nhà hàng' : 'Thêm nhà hàng mới',
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: kSpacingL, vertical: kSpacingL),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- Tên nhà hàng ---
              AppTextField(
                controller: _nameController,
                labelText: 'Tên nhà hàng',
                hintText: 'VD: Mumi Bistro & Coffee',
                validator: ValidatorUtils.notEmpty,
              ),
              vSpaceM,
              // --- Địa chỉ ---
              AppTextField(
                controller: _addressController,
                labelText: 'Địa chỉ',
                hintText: 'Nhập địa chỉ cụ thể',
                validator: ValidatorUtils.notEmpty,
              ),
              vSpaceM,
              // --- Mô tả ---
              AppTextField(
                controller: _descriptionController,
                labelText: 'Mô tả',
                hintText: 'Giới thiệu ngắn gọn về nhà hàng...',
                maxLines: 4,
                validator: ValidatorUtils.notEmpty,
              ),
              vSpaceM,

              // --- Mức giá ---
              AppTextField(
                controller: _priceRangeController,
                labelText: 'Mức giá trung bình',
                hintText: 'VD: 100,000 - 300,000 VNĐ',
                validator: ValidatorUtils.notEmpty,
              ),
              vSpaceXL,
              // --- Nút hành động ---
              AppButton(
                text: isEdit ? 'Lưu thay đổi' : 'Gửi chờ duyệt',
                onPressed: _saveRestaurant,
              ),
              vSpaceL,
            ],
          ),
        ),
      ),
    );
  }
}
