import 'package:flutter/material.dart';
import 'package:mumiappfood/core/constants/app_icons.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/core/constants/colors.dart';

import '../../../../l10n/app_localizations.dart';

class HomeSearchBar extends StatelessWidget {
  final VoidCallback? onFilterTap;

  const HomeSearchBar({super.key, this.onFilterTap});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return InkWell(
      onTap: () {
        // TODO: Điều hướng đến trang tìm kiếm chuyên dụng
        print('Navigate to Search Page');
      },
      borderRadius: BorderRadius.circular(30.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: kSpacingM, vertical: 12.0),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(30.0),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Icon(AppIcons.search, color: Colors.grey[600]),
            hSpaceS,
            Expanded(
              child: Text(
                localizations.searchRestaurantsCuisine,
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
              ),
            ),
            InkWell(
              onTap: onFilterTap,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Icon(Icons.tune_outlined, color: Theme.of(context).primaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
