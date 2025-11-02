import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/core/constants/colors.dart';
import 'package:mumiappfood/core/utils/validator_utils.dart';
import 'package:mumiappfood/core/widgets/app_button.dart';
import 'package:mumiappfood/core/widgets/app_snackbar.dart';
import 'package:mumiappfood/core/widgets/app_textfield.dart';
import 'package:mumiappfood/features/owner_dashboard/state/add_edit_restaurant_cubit.dart';
import 'package:mumiappfood/routes/app_router.dart';

class AddEditRestaurantPage extends StatefulWidget {
  final String? restaurantId;
  const AddEditRestaurantPage({super.key, this.restaurantId});
  bool get isEditMode => restaurantId != null;

  @override
  State<AddEditRestaurantPage> createState() => _AddEditRestaurantPageState();
}

class _AddEditRestaurantPageState extends State<AddEditRestaurantPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  LatLng? _selectedLatLng;

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _openMapPicker() async {
    final result = await context.pushNamed<Map<String, dynamic>>(AppRouteNames.mapPicker);
    if (result != null && mounted) {
      setState(() {
        _selectedLatLng = result['latlng'] as LatLng?;
        if (result.containsKey('address')) {
          _addressController.text = result['address'] as String;
        }
      });
    }
  }

  void _saveRestaurant(BuildContext cubitContext) {
    if (_formKey.currentState!.validate()) {
      if (_selectedLatLng == null) {
        AppSnackbar.showError(cubitContext, 'Vui lòng chọn vị trí trên bản đồ.');
        return;
      }
      FocusScope.of(cubitContext).unfocus();
      
      final cubit = cubitContext.read<AddEditRestaurantCubit>();
      final avgPrice = double.tryParse(_priceController.text.replaceAll('.', '')) ?? 0.0;

      if (widget.isEditMode) {
        cubit.updateRestaurant(
          restaurantId: widget.restaurantId!,
          name: _nameController.text,
          address: _addressController.text,
          description: _descriptionController.text,
          avgPrice: avgPrice,
          latitude: _selectedLatLng!.latitude,
          longitude: _selectedLatLng!.longitude,
        );
      } else {
        cubit.addRestaurant(
          name: _nameController.text,
          address: _addressController.text,
          description: _descriptionController.text,
          avgPrice: avgPrice,
          latitude: _selectedLatLng!.latitude,
          longitude: _selectedLatLng!.longitude,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = AddEditRestaurantCubit();
        if (widget.isEditMode) {
          cubit.loadRestaurantForEdit(widget.restaurantId!);
        }
        return cubit;
      },
      child: Scaffold(
        appBar: AppBar(
          // SỬA LỖI: Thêm style bold cho tiêu đề
          title: Text(
            widget.isEditMode ? 'Sửa nhà hàng' : 'Thêm nhà hàng mới',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: BlocBuilder<AddEditRestaurantCubit, AddEditRestaurantState>(
          builder: (context, state) {
            return Scaffold(
              bottomNavigationBar: _buildPersistentSaveButton(context, state),
              body: BlocListener<AddEditRestaurantCubit, AddEditRestaurantState>(
                listener: (context, state) {
                  if (state is AddEditRestaurantDataLoaded) {
                    final data = state.restaurantData;
                    _nameController.text = data['name'] ?? '';
                    _addressController.text = data['address'] ?? '';
                    _descriptionController.text = data['description'] ?? '';
                    _priceController.text = (data['avgPrice'] as num?)?.toInt().toString() ?? '';
                    if (data['latitude'] != null && data['longitude'] != null) {
                      setState(() {
                         _selectedLatLng = LatLng(data['latitude'], data['longitude']);
                      });
                    }
                  } else if (state is AddEditRestaurantSuccess) {
                    final message = widget.isEditMode 
                        ? 'Cập nhật nhà hàng thành công!' 
                        : 'Thêm nhà hàng thành công! Đang chờ duyệt.';
                    AppSnackbar.showSuccess(context, message);
                    context.pop(true);
                  } else if (state is AddEditRestaurantError) {
                    AppSnackbar.showError(context, state.message);
                  }
                },
                child: Builder(
                  builder: (context) {
                     if (state is AddEditRestaurantLoadingData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(kSpacingM, kSpacingL, kSpacingM, 100),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Thông tin cơ bản', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                            vSpaceM,
                            AppTextField(controller: _nameController, labelText: 'Tên nhà hàng', hintText: 'VD: Bún Bò Huế O Ty', validator: ValidatorUtils.notEmpty),
                            vSpaceM,
                            AppTextField(controller: _descriptionController, labelText: 'Mô tả', hintText: 'Giới thiệu các món ăn đặc sắc, không gian,...', maxLines: 4, validator: ValidatorUtils.notEmpty),
                            vSpaceM,
                            AppTextField(
                              controller: _priceController,
                              labelText: 'Mức giá trung bình / người (VNĐ)',
                              hintText: 'Nhập mức giá trung bình cho một người',
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              validator: ValidatorUtils.notEmpty,
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: kSpacingL),
                              child: Divider(color: AppColors.border, height: 1),
                            ),
                            Text('Vị trí & Địa chỉ', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                            vSpaceM,
                            InkWell(
                              onTap: _openMapPicker,
                              borderRadius: BorderRadius.circular(12),
                              child: AbsorbPointer(
                                child: AppTextField(
                                  controller: _addressController,
                                  labelText: 'Địa chỉ',
                                  hintText: 'Nhấn để mở bản đồ và chọn vị trí',
                                  validator: ValidatorUtils.notEmpty,
                                  maxLines: 2,
                                  suffixIcon: _selectedLatLng != null ? Icons.check_circle : Icons.map_outlined,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                ),
              ),
            );
          },
        ),
      ),
    );
  }
  
  Widget _buildPersistentSaveButton(BuildContext context, AddEditRestaurantState state) {
    return Container(
      padding: const EdgeInsets.all(kSpacingM).copyWith(top: kSpacingS),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5)),
        ],
      ),
      child: AppButton(
        text: widget.isEditMode ? 'Lưu thay đổi' : 'Gửi yêu cầu',
        isLoading: state is AddEditRestaurantSaving,
        onPressed: () => _saveRestaurant(context),
      ),
    );
  }
}
