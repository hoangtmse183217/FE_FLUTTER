import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mumiappfood/features/moods/data/models/mood_model.dart';
import 'package:mumiappfood/features/moods/data/repositories/mood_repository.dart';
import 'package:mumiappfood/features/moods/state/mood_state.dart';

class MoodCubit extends Cubit<MoodState> {
  final MoodRepository _moodRepository;

  MoodCubit() 
      : _moodRepository = MoodRepository(), 
        super(const MoodInitial());

  Future<void> getMoods() async {
    emit(const MoodLoading());
    try {
      // 1. Lấy về List<dynamic> từ repository
      final dynamicMoods = await _moodRepository.getMoods();

      // 2. Chuyển đổi List<dynamic> thành List<Mood> ngay tại đây
      final moods = dynamicMoods
          .map((json) => Mood.fromJson(json as Map<String, dynamic>))
          .toList();

      // 3. Emit state với danh sách đã được chuyển đổi chính xác
      emit(MoodLoaded(moods));
      
    } catch (e) {
      emit(MoodError(e.toString()));
    }
  }
}
