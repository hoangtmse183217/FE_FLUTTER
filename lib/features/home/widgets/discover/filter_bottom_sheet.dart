import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/features/home/data/models/discover_filter_model.dart';
import 'package:mumiappfood/features/map/views/map_picker_page.dart'; // SỬA ĐỔI: Đường dẫn import đúng kiến trúc

class FilterBottomSheet extends StatefulWidget {
  final DiscoverFilter initialFilter;

  const FilterBottomSheet({super.key, required this.initialFilter});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late RangeValues _currentPriceRange;
  late double _currentMinRating;
  late LatLng? _selectedLocation;
  late double? _selectedRadiusKm;

  final double _minPrice = 0;
  final double _maxPrice = 500000;

  @override
  void initState() {
    super.initState();
    _resetToInitial(widget.initialFilter);
  }

  void _resetToInitial(DiscoverFilter filter) {
    _currentPriceRange = RangeValues(
      filter.minPrice ?? _minPrice,
      filter.maxPrice ?? _maxPrice,
    );
    _currentMinRating = filter.minRating ?? 0;
    _selectedLocation = filter.location;
    _selectedRadiusKm = filter.radiusKm;
  }

  void _openMapPicker() async {
    // SỬA LỖI LOGIC: Nhận về trực tiếp LatLng
    final LatLng? pickedLocation = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const MapPickerPage()),
    );

    if (pickedLocation != null) {
      setState(() {
        _selectedLocation = pickedLocation;
        if (_selectedRadiusKm == null) {
          _selectedRadiusKm = 5; // Giá trị mặc định
        }
      });
    }
  }

  void _applyFilters() {
    final newFilter = DiscoverFilter(
      query: widget.initialFilter.query,
      minPrice: _currentPriceRange.start > _minPrice ? _currentPriceRange.start : null,
      maxPrice: _currentPriceRange.end < _maxPrice ? _currentPriceRange.end : null,
      minRating: _currentMinRating > 0 ? _currentMinRating : null,
      location: _selectedLocation,
      radiusKm: _selectedRadiusKm,
    );
    Navigator.of(context).pop(newFilter);
  }

  void _resetAndClose() {
    Navigator.of(context).pop(const DiscoverFilter.empty());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(kSpacingL),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Bộ lọc', style: Theme.of(context).textTheme.headlineSmall),
              TextButton(
                onPressed: _resetAndClose,
                child: const Text('Reset'),
              ),
            ],
          ),
          const Divider(height: kSpacingL),

          _buildSectionTitle(context, 'Vị trí'),
          ListTile(
            leading: const Icon(Icons.location_on_outlined),
            title: Text(_selectedLocation == null ? 'Chọn vị trí' : 'Đã chọn vị trí'),
            subtitle: _selectedLocation != null ? Text('Lat: ${_selectedLocation!.latitude.toStringAsFixed(4)}, Lng: ${_selectedLocation!.longitude.toStringAsFixed(4)}') : null,
            trailing: _selectedLocation != null ? IconButton(icon: const Icon(Icons.clear, color: Colors.red), onPressed: () => setState(() { _selectedLocation = null; _selectedRadiusKm = null; })) : null,
            onTap: _openMapPicker,
          ),
          if (_selectedLocation != null) _buildRadiusSlider(),
          const Divider(height: kSpacingXL),

          _buildSectionTitle(context, 'Khoảng giá'),
          RangeSlider(
            values: _currentPriceRange,
            min: _minPrice,
            max: _maxPrice,
            divisions: 20,
            labels: RangeLabels('${_currentPriceRange.start.round()}k', '${_currentPriceRange.end.round()}k'),
            onChanged: (values) => setState(() => _currentPriceRange = values),
          ),
          const Divider(height: kSpacingXL),

          _buildSectionTitle(context, 'Đánh giá tối thiểu'),
          Row(
            children: List.generate(5, (index) {
              final rating = index + 1.0;
              return IconButton(
                icon: Icon(rating <= _currentMinRating ? Icons.star : Icons.star_border, color: Colors.amber),
                onPressed: () => setState(() => _currentMinRating = _currentMinRating == rating ? 0 : rating),
              );
            }),
          ),
          vSpaceL,

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _applyFilters,
              child: const Text('Áp dụng'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadiusSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text('Phạm vi: ${_selectedRadiusKm?.toStringAsFixed(1) ?? '5.0'} km', style: Theme.of(context).textTheme.bodyMedium),
        ),
        Slider(
          value: _selectedRadiusKm ?? 5.0,
          min: 1.0,
          max: 20.0,
          divisions: 19,
          label: '${(_selectedRadiusKm ?? 5.0).toStringAsFixed(1)} km',
          onChanged: (value) => setState(() => _selectedRadiusKm = value),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: kSpacingS),
      child: Text(title, style: Theme.of(context).textTheme.titleLarge),
    );
  }
}
