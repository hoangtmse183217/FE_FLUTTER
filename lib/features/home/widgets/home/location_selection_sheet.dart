import 'package:flutter/material.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';

class LocationSelectionSheet extends StatefulWidget {
  final String? currentAddress;
  final Future<void> Function() onRefreshLocation;

  const LocationSelectionSheet({
    super.key,
    this.currentAddress,
    required this.onRefreshLocation,
  });

  @override
  State<LocationSelectionSheet> createState() => _LocationSelectionSheetState();
}

class _LocationSelectionSheetState extends State<LocationSelectionSheet> {
  bool _isLoading = false;

  Future<void> _handleRefresh() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await widget.onRefreshLocation();
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(localizations.selectYourLocation, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          vSpaceM,
          if (widget.currentAddress != null && widget.currentAddress!.isNotEmpty)
            Card(
              elevation: 0,
              color: Colors.grey[200],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              child: ListTile(
                dense: true,
                leading: Icon(Icons.my_location, color: Theme.of(context).primaryColor),
                title: Text(localizations.yourCurrentLocation, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(widget.currentAddress!, style: TextStyle(color: Colors.grey[700])),
              ),
            ),
          vSpaceM,
          ListTile(
            leading: _isLoading
                ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                : Icon(Icons.replay, color: Theme.of(context).primaryColor),
            title: Text(_isLoading ? localizations.updating : localizations.refreshLocation),
            onTap: _handleRefresh,
          ),
        ],
      ),
    );
  }
}
