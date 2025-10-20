import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:mumiappfood/core/constants/app_spacing.dart';
import 'package:mumiappfood/core/widgets/app_snackbar.dart';

import '../../../l10n/app_localizations.dart';
import '../../../routes/app_router.dart';
import '../widgets/home/location_display.dart';
import '../widgets/home/location_selection_sheet.dart';
import '../widgets/home/mood_selector.dart';
import '../widgets/home/restaurant_card.dart';
import '../widgets/home/section_header.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String? _currentLocation;

  @override
  void initState() {
    super.initState();
    // Tự động lấy vị trí lần đầu tiên khi trang được tạo
    _fetchCurrentAddress(showError: false);
  }

  Future<void> _fetchCurrentAddress({bool showError = true}) async {
    final localizations = AppLocalizations.of(context)!;
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (showError && mounted) AppSnackbar.showError(context, localizations.locationServicesOff);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (showError && mounted) AppSnackbar.showError(context, localizations.locationPermissionDenied);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (showError && mounted) AppSnackbar.showError(context, localizations.locationPermissionPermanentlyDenied);
        return;
      }

      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);
      if (!mounted) return;

      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        final addressComponents = [place.street, place.subLocality, place.subAdministrativeArea, place.administrativeArea];
        final fullAddress = addressComponents.where((c) => c != null && c.isNotEmpty).join(', ');
        if (mounted) {
          setState(() { _currentLocation = fullAddress; });
        }
      }
    } catch (e) {
      if (showError && mounted) AppSnackbar.showError(context, localizations.cannotGetLocation);
    }
  }

  void _showLocationPicker() async {
    final localizations = AppLocalizations.of(context)!;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (BuildContext context) {
        return LocationSelectionSheet(
          currentAddress: _currentLocation,
          onRefreshLocation: _fetchCurrentAddress,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final userName = FirebaseAuth.instance.currentUser?.displayName ?? localizations.user;

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: kSpacingM),
          child: LocationDisplay(
            location: _currentLocation ?? localizations.selectYourLocation,
            onTap: _showLocationPicker,
          ),
        ),
        leadingWidth: 250,
        title: const Text(''),
        elevation: 0.5,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [
          IconButton(
            onPressed: () => context.pushNamed(AppRouteNames.notifications),
            icon: const Icon(Icons.notifications_none_outlined, size: 28),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(kSpacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations.helloUser(userName),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            vSpaceS,
            Text(
              localizations.howAreYouFeelingToday,
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            vSpaceM,
            const MoodSelector(),
            vSpaceL,
            SectionHeader(title: localizations.featuredSuggestions, onSeeAll: () {
              // TODO: Điều hướng sang trang Khám phá
            }),
            vSpaceM,
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 2, // Dữ liệu giả
              separatorBuilder: (context, index) => vSpaceM,
              itemBuilder: (context, index) {
                return RestaurantCard(
                  restaurantId: 'home-suggestion-${index + 1}',
                  name: index == 0 ? 'Cuc Gach Quan' : 'Pizza 4P\'s',
                  imageUrl: index == 0
                      ? 'https://images.unsplash.com/photo-1552566626-52f8b828add9?w=500'
                      : 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=500',
                  cuisine: index == 0 ? localizations.vietnameseCuisine : localizations.pizzaAndPasta,
                  rating: index == 0 ? 4.8 : 4.9,
                  moods: index == 0 ? [localizations.family, localizations.relaxing] : [localizations.family, localizations.romantic],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
