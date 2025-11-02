import 'package:flutter/foundation.dart';
import 'package:mumiappfood/features/moods/data/models/mood_model.dart';

@immutable
abstract class MoodState {
  const MoodState();
}

class MoodInitial extends MoodState {
  const MoodInitial();
}

class MoodLoading extends MoodState {
  const MoodLoading();
}

class MoodLoaded extends MoodState {
  final List<Mood> moods;
  const MoodLoaded(this.moods);
}

class MoodError extends MoodState {
  final String message;
  const MoodError(this.message);
}
