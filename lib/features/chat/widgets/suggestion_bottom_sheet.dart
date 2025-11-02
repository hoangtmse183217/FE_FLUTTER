import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/core/widgets/app_button.dart';
import 'package:mumiappfood/features/chat/state/chat_cubit.dart';
import 'package:mumiappfood/features/map/views/map_picker_page.dart';
import 'package:mumiappfood/features/moods/data/models/mood_model.dart';
import 'package:mumiappfood/features/moods/state/mood_cubit.dart';
import 'package:mumiappfood/features/moods/state/mood_state.dart';

class SuggestionBottomSheet extends StatelessWidget {
  const SuggestionBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    // Cung cấp MoodCubit cho widget này và các con của nó
    return BlocProvider(
      create: (context) => MoodCubit()..getMoods(),
      child: const _SuggestionForm(),
    );
  }
}

class _SuggestionForm extends StatefulWidget {
  const _SuggestionForm();

  @override
  State<_SuggestionForm> createState() => _SuggestionFormState();
}

class _SuggestionFormState extends State<_SuggestionForm> {
  Mood? _selectedMood;
  String _selectedLocation = "Nhấn để chọn địa điểm";
  LatLng? _selectedLatLng;

  Future<void> _pickLocation() async {
    final result = await Navigator.push<LatLng>(
      context,
      MaterialPageRoute(builder: (context) => const MapPickerPage()),
    );

    if (result != null) {
      setState(() {
        _selectedLatLng = result;
        _selectedLocation = "Đang lấy địa chỉ...";
      });

      try {
        final placemarks = await placemarkFromCoordinates(result.latitude, result.longitude);
        if (placemarks.isNotEmpty) {
          final p = placemarks.first;
          setState(() {
            _selectedLocation = "${p.street}, ${p.subAdministrativeArea}, ${p.administrativeArea}";
          });
        }
      } catch (e) {
        setState(() => _selectedLocation = "Không thể lấy tên địa chỉ");
      }
    }
  }

  void _getSuggestions() {
    if (_selectedMood == null || _selectedLatLng == null) {
      // Hiển thị thông báo lỗi cho người dùng
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn tâm trạng và địa điểm.')),
      );
      return;
    }

    // Gọi Cubit và đóng bottom sheet
    context.read<ChatCubit>().getMoodSuggestions(_selectedMood!.name, _selectedLocation);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(kSpacingL),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gợi ý nâng cao',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          vSpaceM,
          // Phần chọn Mood
          _buildMoodSelector(),
          vSpaceL,
          // Phần chọn Địa điểm
          Text('Địa điểm của bạn', style: Theme.of(context).textTheme.titleLarge),
          vSpaceM,
          InkWell(
            onTap: _pickLocation,
            child: InputDecorator(
              decoration: const InputDecoration(border: OutlineInputBorder()),
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.red),
                  hSpaceM,
                  Expanded(child: Text(_selectedLocation, overflow: TextOverflow.ellipsis)),
                ],
              ),
            ),
          ),
          vSpaceXL,
          // Nút xác nhận
          AppButton(
            text: 'Tìm gợi ý cho tôi',
            onPressed: _getSuggestions,
          ),
          vSpaceM, // Thêm khoảng trống để không bị che khuất
        ],
      ),
    );
  }

  Widget _buildMoodSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tâm trạng của bạn', style: Theme.of(context).textTheme.titleLarge),
        vSpaceM,
        BlocBuilder<MoodCubit, MoodState>(
          builder: (context, state) {
            if (state is MoodLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is MoodError) {
              return Text('Lỗi: ${state.message}');
            }
            if (state is MoodLoaded) {
              return Wrap(
                spacing: kSpacingS,
                runSpacing: kSpacingS,
                children: state.moods.map((mood) {
                  final isSelected = _selectedMood?.id == mood.id;
                  return ChoiceChip(
                    label: Text(mood.name),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedMood = selected ? mood : null;
                      });
                    },
                    selectedColor: Theme.of(context).primaryColor,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  );
                }).toList(),
              );
            }
            return const Text('Nhấn để tải danh sách tâm trạng');
          },
        ),
      ],
    );
  }
}
