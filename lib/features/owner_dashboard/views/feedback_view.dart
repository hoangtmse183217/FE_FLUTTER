import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/features/owner_dashboard/state/feedback_cubit.dart';
import 'package:mumiappfood/features/owner_dashboard/widgets/feedback/review_card.dart';

class FeedbackView extends StatelessWidget {
  const FeedbackView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FeedbackCubit()..fetchReviews(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Phản hồi & Đánh giá'),
        ),
        body: BlocBuilder<FeedbackCubit, FeedbackState>(
          builder: (context, state) {
            if (state is FeedbackLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is FeedbackError) {
              return Center(child: Text(state.message));
            }
            if (state is FeedbackLoaded) {
              if (state.reviews.isEmpty) {
                return const Center(child: Text('Chưa có đánh giá nào.'));
              }
              return ListView.separated(
                padding: const EdgeInsets.all(kSpacingM),
                itemCount: state.reviews.length,
                separatorBuilder: (context, index) => vSpaceM,
                itemBuilder: (context, index) {
                  return ReviewCard(review: state.reviews[index]);
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}