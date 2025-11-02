import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mumiappfood/features/post/state/post_cubit.dart';
import 'package:mumiappfood/features/post/views/post_feed_view.dart';

class PostFeedPage extends StatelessWidget {
  const PostFeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostCubit()..fetchPosts(),
      child: const PostFeedView(),
    );
  }
}
