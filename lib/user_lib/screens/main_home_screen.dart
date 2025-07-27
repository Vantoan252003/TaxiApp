import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../general_lib/constants/app_constants.dart';
import '../../general_lib/constants/app_theme.dart';
import '../../general_lib/core/providers/auth_provider.dart';
import '../../general_lib/providers/place_search_provider.dart';
import '../../general_lib/repositories/place_repository.dart';
import '../../general_lib/usecases/place_usecases.dart';
import '../widgets/home_banner_section.dart';
import '../widgets/home_location_section.dart';
import '../widgets/home_services_grid.dart';
import '../widgets/home_suggestion_section.dart';
import 'destination_search_screen.dart';

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  late PlaceSearchProvider _placeSearchProvider;

  @override
  void initState() {
    super.initState();
    _initializeProvider();
    _getCurrentLocation();
    _loadUserInfo();
  }

  void _initializeProvider() {
    final repository = const PlaceRepository();
    final searchPlacesUseCase = SearchPlacesUseCase(repository);
    final getCurrentAddressUseCase = GetCurrentAddressUseCase(repository);

    _placeSearchProvider = PlaceSearchProvider(
      searchPlacesUseCase: searchPlacesUseCase,
      getCurrentAddressUseCase: getCurrentAddressUseCase,
    );
  }

  Future<void> _getCurrentLocation() async {
    await _placeSearchProvider.getCurrentLocation();
  }

  Future<void> _loadUserInfo() async {
    // Load user info từ API khi vào màn hình
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.loadUserInfo();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _showFeatureInDevelopment(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature ${AppConstants.featureInDevelopment}')),
    );
  }

  Future<void> _openDestinationSearch() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const DestinationSearchScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PlaceSearchProvider>(
      create: (context) => _placeSearchProvider,
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        body: SafeArea(
          child: Consumer2<PlaceSearchProvider, AuthProvider>(
            builder: (context, placeProvider, authProvider, child) {
              return Column(
                children: [
                  // Banner Section with banner.png
                  const HomeBannerSection(),

                  // Location Input Section
                  HomeLocationSection(
                    currentLocation: placeProvider.isLoadingLocation
                        ? AppConstants.loadingLocationText
                        : placeProvider.currentLocation,
                    isLoadingLocation: placeProvider.isLoadingLocation,
                    destinationHint: AppConstants.destinationPlaceholder,
                    onCurrentLocationTap: _getCurrentLocation,
                    onDestinationTap: _openDestinationSearch,
                  ),

                  // Services Grid
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: AppTheme.backgroundColor,
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
                                    _showFeatureInDevelopment(
                                        'Dịch vụ $serviceType'),
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
              );
            },
          ),
        ),
      ),
    );
  }
}
