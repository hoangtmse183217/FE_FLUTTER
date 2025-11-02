part of 'add_edit_post_cubit.dart';

@immutable
abstract class AddEditPostState {}

class AddEditPostInitial extends AddEditPostState {}

class AddEditPostLoadingData extends AddEditPostState {} // Đang tải dữ liệu ban đầu

class AddEditPostError extends AddEditPostState {
  final String message;
  AddEditPostError(this.message);
}

class AddEditPostReady extends AddEditPostState {
  final List<Map<String, dynamic>> approvedRestaurants;
  final List<Map<String, dynamic>> allMoods;
  final Map<String, dynamic>? initialPostData;
  final XFile? newImageFile;
  final bool isSaving;

  AddEditPostReady({
    required this.approvedRestaurants,
    required this.allMoods,
    this.initialPostData,
    this.newImageFile,
    this.isSaving = false,
  });

  AddEditPostReady copyWith({
    List<Map<String, dynamic>>? approvedRestaurants,
    List<Map<String, dynamic>>? allMoods,
    Map<String, dynamic>? initialPostData,
    XFile? newImageFile,
    bool? isSaving,
  }) {
    return AddEditPostReady(
      approvedRestaurants: approvedRestaurants ?? this.approvedRestaurants,
      allMoods: allMoods ?? this.allMoods,
      initialPostData: initialPostData ?? this.initialPostData,
      newImageFile: newImageFile ?? this.newImageFile,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}

class AddEditPostSuccess extends AddEditPostState {}
