import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/core/constants/colors.dart';
import 'package:mumiappfood/core/widgets/app_button.dart';
import 'package:mumiappfood/core/widgets/app_snackbar.dart';
import 'package:mumiappfood/core/widgets/app_textfield.dart';
import 'package:mumiappfood/core/widgets/empty_state_widget.dart';
import 'package:mumiappfood/features/owner_dashboard/state/add_edit_post_cubit.dart';

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
  int? _selectedRestaurantId;
  String? _existingImageUrl;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _savePost(BuildContext context) {
    // Validator của Dropdown đã đảm bảo _selectedRestaurantId không phải là null nếu form hợp lệ.
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AddEditPostCubit>().submitPost(
        postId: widget.postId,
        title: _titleController.text,
        content: _contentController.text,
        // SỬA LỖI: Thêm toán tử ! để khẳng định giá trị không null.
        restaurantId: _selectedRestaurantId!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = AddEditPostCubit();
        if (widget.isEditMode) {
          cubit.loadPostForEdit(widget.postId!);
        } else {
          cubit.loadDataForCreate();
        }
        return cubit;
      },
      child: BlocConsumer<AddEditPostCubit, AddEditPostState>(
        listener: (context, state) {
          if (state is AddEditPostReady && state.initialPostData != null && widget.isEditMode) {
            final postData = state.initialPostData!;
            _titleController.text = postData['title'] ?? '';
            _contentController.text = postData['content'] ?? '';
            setState(() {
              _selectedRestaurantId = postData['restaurantId'];
              _existingImageUrl = postData['imageUrl'];
            });
          }
          if (state is AddEditPostSuccess) {
            final message = widget.isEditMode ? 'Cập nhật bài viết thành công!' : 'Tạo bài viết thành công!';
            AppSnackbar.showSuccess(context, message);
            context.pop(true);
          } else if (state is AddEditPostError) {
            AppSnackbar.showError(context, state.message);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                widget.isEditMode ? 'Sửa bài viết' : 'Tạo bài viết mới',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            bottomNavigationBar: _buildPersistentSaveButton(context, state),
            body: Builder(
              builder: (context) {
                 if (state is AddEditPostLoadingData) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is AddEditPostError) {
                  return EmptyStateWidget(
                    icon: Icons.error_outline,
                    message: 'Không thể tải dữ liệu',
                    details: state.message,
                    onRetry: () {
                      final cubit = context.read<AddEditPostCubit>();
                       if (widget.isEditMode) {
                        cubit.loadPostForEdit(widget.postId!);
                      } else {
                        cubit.loadDataForCreate();
                      }
                    },
                  );
                }
                if (state is AddEditPostReady) {
                  final selectedMoodIds = (state.initialPostData?['moods'] as List<dynamic>? ?? []).map((m) => m['id'] as int).toSet();
                  return SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(kSpacingM, kSpacingL, kSpacingM, 100),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Ảnh bìa', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                          vSpaceS,
                          _buildImagePicker(context, state),
                          vSpaceL,
                          Text('Nội dung bài viết', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                          vSpaceM,
                          AppTextField(controller: _titleController, labelText: 'Tiêu đề', hintText: 'VD: Top 5 món phải thử tại... ', validator: (v) => v!.isEmpty ? 'Tiêu đề không được bỏ trống' : null),
                          vSpaceM,
                          AppTextField(controller: _contentController, labelText: 'Nội dung', hintText: 'Chia sẻ câu chuyện, trải nghiệm của bạn về địa điểm, món ăn,...', maxLines: 8, validator: (v) => v!.isEmpty ? 'Nội dung không được bỏ trống' : null),
                          vSpaceL,
                          Text('Thông tin chi tiết', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                          vSpaceM,
                          _buildRestaurantDropdown(context, state),
                          if (widget.isEditMode && state.allMoods.isNotEmpty) ...[
                            vSpaceL,
                            Text('Chủ đề / Tâm trạng', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                            vSpaceS,
                            _buildMoodChips(context, state, selectedMoodIds),
                          ],
                        ],
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildImagePicker(BuildContext context, AddEditPostReady state) {
    return InkWell(
      onTap: () => context.read<AddEditPostCubit>().pickImage(),
      borderRadius: BorderRadius.circular(12),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
            decoration: BoxDecoration(border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(12)),
            clipBehavior: Clip.antiAlias,
            child: _buildCoverImage(state)),
      ),
    );
  }

  Widget _buildCoverImage(AddEditPostReady state) {
    if (state.newImageFile != null) {
      return Image.file(File(state.newImageFile!.path), fit: BoxFit.cover, width: double.infinity);
    }
    if (_existingImageUrl != null && _existingImageUrl!.isNotEmpty) {
      return Image.network(_existingImageUrl!, fit: BoxFit.cover, width: double.infinity);
    }
    return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Icon(Icons.add_a_photo_outlined, color: AppColors.textSecondary, size: 32),
      vSpaceS,
      Text('Chọn hoặc chụp ảnh bìa', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary))
    ]));
  }

  Widget _buildRestaurantDropdown(BuildContext context, AddEditPostReady state) {
    return DropdownButtonFormField<int>(
      value: _selectedRestaurantId,
      decoration: InputDecoration(
        labelText: 'Bài viết thuộc nhà hàng',
        hintText: state.approvedRestaurants.isEmpty ? 'Bạn chưa có nhà hàng nào được duyệt' : 'Chọn nhà hàng của bạn',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary, width: 2.0)),
      ),
      onChanged: state.approvedRestaurants.isEmpty ? null : (value) => setState(() => _selectedRestaurantId = value),
      items: state.approvedRestaurants.map((r) => DropdownMenuItem(value: r['id'] as int, child: Text(r['name'] as String))).toList(),
      validator: (v) => v == null ? 'Vui lòng chọn nhà hàng cho bài viết' : null,
      isExpanded: true,
    );
  }

  Widget _buildMoodChips(BuildContext context, AddEditPostReady state, Set<int> selectedMoodIds) {
    return Wrap(
      spacing: kSpacingS,
      runSpacing: kSpacingS,
      children: state.allMoods.map((mood) {
        final isSelected = selectedMoodIds.contains(mood['id']);
        return ChoiceChip(
          label: Text(mood['name'] as String),
          selected: isSelected,
          onSelected: (selected) {
            context.read<AddEditPostCubit>().toggleMood(widget.postId!, mood);
          },
          selectedColor: AppColors.primary,
          backgroundColor: AppColors.background,
          labelStyle: TextStyle(color: isSelected ? Colors.white : AppColors.textPrimary, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
          side: isSelected ? BorderSide.none : const BorderSide(color: AppColors.border),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        );
      }).toList(),
    );
  }
  
  Widget _buildPersistentSaveButton(BuildContext context, AddEditPostState state) {
     return Container(
      padding: const EdgeInsets.all(kSpacingM).copyWith(top: kSpacingS),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: AppButton(
        text: widget.isEditMode ? 'Lưu thay đổi' : 'Gửi duyệt bài viết',
        isLoading: state is AddEditPostReady ? state.isSaving : false,
        onPressed: () => _savePost(context),
      ),
    );
  }
}
