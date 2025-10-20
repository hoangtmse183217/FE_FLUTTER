import 'package:flutter/material.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/core/constants/colors.dart';
import 'package:mumiappfood/core/widgets/app_button.dart';

import '../../../../l10n/app_localizations.dart';

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
  late Set<String> _selectedPriceKeys;
  late double _minRating;

  // Sử dụng một Map với key ổn định và value được bản địa hóa
  Map<String, String> _getPriceOptions(AppLocalizations localizations) {
    return {
      '100k': localizations.price100k,
      '500k': localizations.price500k,
      '1m': localizations.price1m,
    };
  }

  @override
  void initState() {
    super.initState();
    _selectedPriceKeys = Set.from(widget.initialPriceRanges);
    _minRating = widget.initialMinRating;
  }

  void _onPriceChipSelected(String priceKey) {
    setState(() {
      if (_selectedPriceKeys.contains(priceKey)) {
        _selectedPriceKeys.remove(priceKey);
      } else {
        _selectedPriceKeys.add(priceKey);
      }
    });
  }

  void _applyFilters() {
    final result = {
      'priceRanges': _selectedPriceKeys,
      'minRating': _minRating,
    };
    Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final priceOptions = _getPriceOptions(localizations);

    return Padding(
      padding: const EdgeInsets.all(kSpacingL),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(localizations.filters, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          vSpaceM,
          Text(localizations.priceLevel, style: const TextStyle(fontWeight: FontWeight.w600)),
          vSpaceS,
          Wrap(
            spacing: kSpacingS,
            children: priceOptions.keys.map((key) {
              return ChoiceChip(
                selectedColor: AppColors.primary,
                label: Text(priceOptions[key]!),
                selected: _selectedPriceKeys.contains(key),
                onSelected: (_) => _onPriceChipSelected(key),
              );
            }).toList(),
          ),
          const Divider(height: kSpacingL),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(localizations.ratingFrom, style: const TextStyle(fontWeight: FontWeight.w600)),
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
            divisions: 10,
            label: _minRating.toStringAsFixed(1),
            onChanged: (newRating) {
              setState(() {
                _minRating = newRating;
              });
            },
          ),
          vSpaceL,
          SizedBox(
            width: double.infinity,
            child: AppButton(
              text: localizations.apply,
              onPressed: _applyFilters,
            ),
          ),
        ],
      ),
    );
  }
}
