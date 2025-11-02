import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/core/constants/colors.dart';
import 'package:mumiappfood/core/widgets/app_error_widget.dart';
import 'package:mumiappfood/features/post/data/models/post_model.dart';
import 'package:mumiappfood/features/post/state/post_cubit.dart';
import 'package:mumiappfood/features/post/state/post_state.dart';
import 'package:mumiappfood/features/post/widgets/post_card.dart';

// Enum cho các tùy chọn sắp xếp
enum SortOption {
  newestFirst,
  oldestFirst,
  nameAZ,
  nameZA,
}

class PostFeedView extends StatefulWidget {
  const PostFeedView({super.key});

  @override
  State<PostFeedView> createState() => _PostFeedViewState();
}

class _PostFeedViewState extends State<PostFeedView> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  SortOption _currentSortOption = SortOption.newestFirst;
  List<dynamic> _selectedMoods = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      if (mounted) {
        setState(() {
          _searchQuery = _searchController.text;
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostCubit, PostState>(
      builder: (context, state) {
        if (state is PostLoading || state is PostInitial) {
          return Scaffold(
            appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        if (state is PostError) {
          return Scaffold(
            appBar: AppBar(title: const Text('Có lỗi xảy ra')),
            body: AppErrorWidget(message: state.message, onRetry: () => context.read<PostCubit>().fetchPosts()),
          );
        }
        if (state is PostsLoaded) {
          return Scaffold(
            appBar: _buildAppBar(context, state.allMoods),
            body: _buildContent(context, state.posts),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  AppBar _buildAppBar(BuildContext context, List<dynamic> allMoods) {
    return AppBar(
      title: TextField(
        controller: _searchController,
        autofocus: false,
        decoration: InputDecoration(
          hintText: 'Tìm theo tên bài viết...',
          border: InputBorder.none,
          hintStyle: TextStyle(color: Colors.grey.shade600),
        ),
        style: const TextStyle(fontSize: 16),
      ),
      actions: [
        if (_searchQuery.isNotEmpty)
          IconButton(
            icon: const Icon(Icons.clear, color: AppColors.textSecondary),
            onPressed: () => _searchController.clear(),
          ),
        // Nút sắp xếp
        PopupMenuButton<SortOption>(
          onSelected: (SortOption result) {
            setState(() {
              _currentSortOption = result;
            });
          },
          icon: const Icon(Icons.sort, color: AppColors.textPrimary),
          itemBuilder: (BuildContext context) => <PopupMenuEntry<SortOption>>[
            const PopupMenuItem<SortOption>(value: SortOption.newestFirst, child: Text('Mới nhất')),
            const PopupMenuItem<SortOption>(value: SortOption.oldestFirst, child: Text('Cũ nhất')),
            const PopupMenuDivider(),
            const PopupMenuItem<SortOption>(value: SortOption.nameAZ, child: Text('Tên: A-Z')),
            const PopupMenuItem<SortOption>(value: SortOption.nameZA, child: Text('Tên: Z-A')),
          ],
        ),
      ],
      bottom: _buildMoodFilterBar(allMoods),
    );
  }
  
  PreferredSize _buildMoodFilterBar(List<dynamic> allMoods) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(50.0),
      child: Container(
        height: 50.0,
        alignment: Alignment.centerLeft,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: kSpacingM, vertical: 8.0),
          itemCount: allMoods.length + 1,
          separatorBuilder: (context, index) => hSpaceS,
          itemBuilder: (context, index) {
            if (index == 0) {
              return ChoiceChip(
                label: const Text('Tất cả'),
                selected: _selectedMoods.isEmpty,
                onSelected: (selected) {
                  setState(() {
                    _selectedMoods.clear();
                  });
                },
                selectedColor: AppColors.primary,
                labelStyle: TextStyle(
                  color: _selectedMoods.isEmpty ? Colors.white : AppColors.textPrimary,
                ),
                backgroundColor: Colors.grey.shade200,
                showCheckmark: false,
                side: BorderSide.none,
              );
            }

            final mood = allMoods[index - 1];
            final bool isSelected = _selectedMoods.any((m) => m['id'] == mood['id']);
            
            return ChoiceChip(
              label: Text(mood['name']),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (isSelected) {
                    _selectedMoods.removeWhere((m) => m['id'] == mood['id']);
                  } else {
                    _selectedMoods.add(mood);
                  }
                });
              },
              selectedColor: AppColors.primary,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : AppColors.textPrimary,
              ),
              backgroundColor: Colors.grey.shade200,
              showCheckmark: false,
              side: BorderSide.none,
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, List<Post> allPosts) {
    List<Post> filteredPosts = allPosts;

    // SỬA LỖI LOGIC: Lọc theo điều kiện AND (phải chứa TẤT CẢ mood đã chọn)
    if (_selectedMoods.isNotEmpty) {
      final selectedMoodIds = _selectedMoods.map((mood) => mood['id'] as int).toSet();
      filteredPosts = filteredPosts.where((post) {
        final postMoodIds = post.moods.map((postMood) => postMood['id'] as int).toSet();
        return postMoodIds.containsAll(selectedMoodIds);
      }).toList();
    }

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filteredPosts = filteredPosts.where((post) {
        return post.title.toLowerCase().contains(query);
      }).toList();
    }

    filteredPosts.sort((a, b) {
      switch (_currentSortOption) {
        case SortOption.oldestFirst:
          return a.createdAt.compareTo(b.createdAt);
        case SortOption.nameAZ:
          return a.title.toLowerCase().compareTo(b.title.toLowerCase());
        case SortOption.nameZA:
          return b.title.toLowerCase().compareTo(a.title.toLowerCase());
        case SortOption.newestFirst:
        default:
          return b.createdAt.compareTo(a.createdAt);
      }
    });

    if (filteredPosts.isEmpty) {
      return Center(
        child: Text(_searchQuery.isNotEmpty || _selectedMoods.isNotEmpty
            ? 'Không tìm thấy bài viết nào phù hợp.'
            : 'Chưa có bài viết nào.'),
      );
    }

    return RefreshIndicator(
      onRefresh: () => context.read<PostCubit>().fetchPosts(),
      child: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: filteredPosts.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: PostCard(post: filteredPosts[index]),
          );
        },
      ),
    );
  }
}
