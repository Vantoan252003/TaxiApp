import 'package:flutter/material.dart';
import '../../general_lib/constants/app_constants.dart';
import '../../general_lib/services/location_service.dart';
import '../widgets/home_banner_section.dart';
import '../widgets/home_location_section.dart';
import '../widgets/home_services_grid.dart';
import '../widgets/home_suggestion_section.dart';

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  String _currentLocation = AppConstants.loadingLocationText;
  bool _isLoadingLocation = true;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoadingLocation = true);

    try {
      final address = await LocationService.getCurrentAddress();
      if (mounted) {
        setState(() {
          _currentLocation = address ?? AppConstants.errorLocationText;
          _isLoadingLocation = false;
        });
      }
    } catch (e) {
      debugPrint('Error in _getCurrentLocation: $e');
      if (mounted) {
        setState(() {
          _currentLocation = AppConstants.errorLocationText;
          _isLoadingLocation = false;
        });
      }
    }
  }

  void _showFeatureInDevelopment(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature ${AppConstants.featureInDevelopment}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F7), // Màu kem nhẹ
      body: SafeArea(
        child: Column(
          children: [
            // Banner Section with banner.png
            const HomeBannerSection(),

            // Location Input Section
            HomeLocationSection(
              currentLocation: _isLoadingLocation
                  ? AppConstants.loadingLocationText
                  : _currentLocation,
              isLoadingLocation: _isLoadingLocation,
              destinationHint: AppConstants.destinationPlaceholder,
              onCurrentLocationTap: _getCurrentLocation,
              onDestinationTap: () =>
                  _showFeatureInDevelopment(AppConstants.destinationFeature),
            ),

            // Services Grid
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFFAF9F7), // Màu kem nhẹ
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(0),
                    topRight: Radius.circular(0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Services Grid
                      Expanded(
                        child: HomeServicesGrid(
                          onServiceTap: (serviceType) =>
                              _showFeatureInDevelopment('Dịch vụ $serviceType'),
                        ),
                      ),
                      // Suggestion Section
                      const HomeSuggestionSection(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
