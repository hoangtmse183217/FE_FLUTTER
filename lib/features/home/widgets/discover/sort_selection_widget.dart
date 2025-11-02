import 'package:flutter/material.dart';
import 'package:mumiappfood/core/models/sort_option.dart';

// SỬA ĐỔI: Biến thành một widget chung, không phụ thuộc vào Cubit
class SortSelectionWidget extends StatelessWidget {
  final SortOption activeSort;
  final ValueChanged<SortOption> onSortChanged;
  final Set<SortOption> disabledOptions;

  const SortSelectionWidget({
    super.key,
    required this.activeSort,
    required this.onSortChanged,
    this.disabledOptions = const {},
  });

  @override
  Widget build(BuildContext context) {
    final options = {
      'Mới nhất': SortOption.latest,
      'A-Z': SortOption.nameAZ,
      'Giá ↑': SortOption.priceAsc,
      'Giá ↓': SortOption.priceDesc,
      'Đánh giá ↓': SortOption.ratingDesc,
      'Gần nhất': SortOption.distance,
    };

    return SizedBox(
      height: 50,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        scrollDirection: Axis.horizontal,
        itemCount: options.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final key = options.keys.elementAt(index);
          final value = options.values.elementAt(index);
          final bool isActive = activeSort == value;
          // Sửa logic: Kiểm tra xem option có nằm trong set bị vô hiệu hóa không
          final bool isDisabled = disabledOptions.contains(value);

          return ChoiceChip(
            label: Text(key),
            selected: isActive,
            onSelected: isDisabled
                ? null // Vô hiệu hóa nút nếu option bị disabled
                : (selected) {
                    if (selected) {
                      onSortChanged(value);
                    }
                  },
            selectedColor: Theme.of(context).primaryColor,
            labelStyle: TextStyle(
              color: isActive ? Colors.white : (isDisabled ? Colors.grey : Theme.of(context).textTheme.bodyLarge?.color),
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
            backgroundColor: Theme.of(context).colorScheme.surface,
            side: BorderSide(color: Colors.grey.shade300),
          );
        },
      ),
    );
  }
}
