import 'package:flutter/material.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/core/constants/colors.dart';
import 'package:mumiappfood/core/widgets/app_button.dart';

class FilterBottomSheet extends StatefulWidget {
  final Set<String> initialPriceRanges;
  final double initialMinRating;

  const FilterBottomSheet({
    super.key,
    required this.initialPriceRanges,
    required this.initialMinRating,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late Set<String> _selectedPriceRanges;
  late double _minRating;

  final List<String> _priceOptions = const ['100.000₫', '500.000₫', '1.000.000₫'];
  // Thêm các lựa chọn khác nếu cần, ví dụ: ẩm thực

  @override
  void initState() {
    super.initState();
    // Khởi tạo state cục bộ từ giá trị ban đầu được truyền vào
    _selectedPriceRanges = Set.from(widget.initialPriceRanges);
    _minRating = widget.initialMinRating;
  }

  void _onPriceChipSelected(String price) {
    setState(() {
      if (_selectedPriceRanges.contains(price)) {
        _selectedPriceRanges.remove(price);
      } else {
        _selectedPriceRanges.add(price);
      }
    });
  }

  void _applyFilters() {
    // Trả về một Map chứa các giá trị đã chọn
    final result = {
      'priceRanges': _selectedPriceRanges,
      'minRating': _minRating,
    };
    Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(kSpacingL),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Bộ lọc', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          vSpaceM,
          // --- LỌC THEO GIÁ ---
          const Text('Mức giá', style: TextStyle(fontWeight: FontWeight.w600)),
          vSpaceS,
          Wrap(
            spacing: kSpacingS,
            children: _priceOptions.map((price) {
              return ChoiceChip(
                selectedColor: AppColors.primary,
                label: Text(price),
                selected: _selectedPriceRanges.contains(price),
                onSelected: (_) => _onPriceChipSelected(price),
              );
            }).toList(),
          ),
          const Divider(height: kSpacingL),
          // --- LỌC THEO RATING ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Rating từ', style: TextStyle(fontWeight: FontWeight.w600)),
              Text(
                '${_minRating.toStringAsFixed(1)} ★',
                style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
              ),
            ],
          ),
          Slider(
            thumbColor: AppColors.primary,
            activeColor: AppColors.primary,
            inactiveColor: Colors.grey[300],
            value: _minRating,
            min: 0,
            max: 5,
            divisions: 10, // 0.5, 1.0, 1.5...
            label: _minRating.toStringAsFixed(1),
            onChanged: (newRating) {
              setState(() {
                _minRating = newRating;
              });
            },
          ),
          vSpaceL,
          // --- NÚT HÀNH ĐỘNG ---
          SizedBox(
            width: double.infinity,
            child: AppButton(
              text: 'Áp dụng',
              onPressed: _applyFilters,
            ),
          ),
        ],
      ),
    );
  }
}