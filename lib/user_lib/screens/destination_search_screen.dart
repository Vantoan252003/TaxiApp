import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../general_lib/constants/app_theme.dart';
import '../../general_lib/models/place_model.dart';
import '../../general_lib/providers/place_search_provider.dart';
import '../../general_lib/repositories/place_repository.dart';
import '../../general_lib/usecases/place_usecases.dart';
import '../widgets/place_search/place_item.dart';
import '../widgets/place_search/place_search_input.dart';
import 'route_map_screen.dart';

class DestinationSearchScreen extends StatefulWidget {
  const DestinationSearchScreen({super.key});

  @override
  State<DestinationSearchScreen> createState() =>
      _DestinationSearchScreenState();
}

class _DestinationSearchScreenState extends State<DestinationSearchScreen> {
  final TextEditingController _originController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final FocusNode _originFocusNode = FocusNode();
  final FocusNode _destinationFocusNode = FocusNode();

  late PlaceSearchProvider _placeSearchProvider;
  bool _isSearchingOrigin = false;

  @override
  void initState() {
    super.initState();
    _initializeProvider();
    _setupListeners();
    _loadCachedLocation();
  }

  @override
  void dispose() {
    _originController.dispose();
    _destinationController.dispose();
    _originFocusNode.dispose();
    _destinationFocusNode.dispose();
    super.dispose();
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

  void _setupListeners() {
    _originController.addListener(_onOriginChanged);
    _destinationController.addListener(_onDestinationChanged);
  }

  Future<void> _loadCachedLocation() async {
    await _placeSearchProvider.getCurrentLocation();
    // Tự động set current location làm origin
    if (_placeSearchProvider.currentLocation.isNotEmpty) {
      _placeSearchProvider.useCurrentLocationAsOrigin();
      _originController.text = _placeSearchProvider.currentLocation;
    }
  }

  void _onOriginChanged() {
    final query = _originController.text.trim();
    if (query.isNotEmpty && query.length >= 2) {
      _placeSearchProvider.searchPlaces(query, isOrigin: true);
      _isSearchingOrigin = true;
    } else {
      _placeSearchProvider.clearSearch();
    }
  }

  void _onDestinationChanged() {
    final query = _destinationController.text.trim();
    if (query.isNotEmpty && query.length >= 2) {
      _placeSearchProvider.searchPlaces(query, isOrigin: false);
      _isSearchingOrigin = false;
    } else {
      _placeSearchProvider.clearSearch();
    }
  }

  void _selectPlace(PlaceModel place) {
    if (_isSearchingOrigin) {
      _placeSearchProvider.selectOrigin(place);
      _originController.text = place.display;
      _originFocusNode.unfocus();
    } else {
      _placeSearchProvider.selectDestination(place);
      _destinationController.text = place.display;
      _destinationFocusNode.unfocus();
    }
    _placeSearchProvider.clearSearch();
  }

  void _useCurrentLocation() {
    _placeSearchProvider.useCurrentLocationAsOrigin();
    _originController.text = _placeSearchProvider.currentLocation;
  }

  void _openMap() {
    if (_placeSearchProvider.canOpenMap) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => RouteMapScreen(
            origin: {
              'name': _placeSearchProvider.selectedOrigin!.name,
              'address': _placeSearchProvider.selectedOrigin!.address,
              'lat': _placeSearchProvider.selectedOrigin!.latitude ?? 10.759091,
              'lng':
                  _placeSearchProvider.selectedOrigin!.longitude ?? 106.675817,
            },
            destination: {
              'name': _placeSearchProvider.selectedDestination!.name,
              'address': _placeSearchProvider.selectedDestination!.address,
              'lat': _placeSearchProvider.selectedDestination!.latitude ??
                  10.762528,
              'lng': _placeSearchProvider.selectedDestination!.longitude ??
                  106.653099,
            },
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng chọn điểm đi và điểm đến'),
          backgroundColor: AppTheme.warningRed,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PlaceSearchProvider>(
      create: (context) => _placeSearchProvider,
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        appBar: AppBar(
          backgroundColor: AppTheme.cardBackground,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppTheme.primaryBlack),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text(
            'Chọn điểm đi và điểm đến',
            style: AppTheme.heading3,
          ),
          actions: [
            Consumer<PlaceSearchProvider>(
              builder: (context, provider, child) {
                if (provider.canOpenMap) {
                  return Container(
                    margin: const EdgeInsets.only(right: 16),
                    child: ElevatedButton(
                      onPressed: _openMap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accentBlue,
                        foregroundColor: AppTheme.primaryWhite,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Xem bản đồ',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
        body: Consumer<PlaceSearchProvider>(
          builder: (context, provider, child) {
            return Column(
              children: [
                // Origin Input Section
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.cardBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.lightGray.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppTheme.accentBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.my_location,
                          color: AppTheme.accentBlue,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Điểm đi',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.lightGray,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            PlaceSearchInput(
                              controller: _originController,
                              focusNode: _originFocusNode,
                              hintText: 'Nhập điểm đi...',
                              onClear: () {
                                _originController.clear();
                                provider.clearOrigin();
                              },
                              onChanged: (value) {
                                // Handled by listener
                              },
                            ),
                          ],
                        ),
                      ),
                      if (!provider.isLoadingLocation &&
                          provider.currentLocation.isNotEmpty)
                        IconButton(
                          onPressed: _useCurrentLocation,
                          icon: const Icon(
                            Icons.gps_fixed,
                            color: AppTheme.accentBlue,
                            size: 20,
                          ),
                          tooltip: 'Vị trí hiện tại',
                        ),
                    ],
                  ),
                ),

                // Destination Input Section
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.cardBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.lightGray.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppTheme.warningRed.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.location_on,
                          color: AppTheme.warningRed,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Điểm đến',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.lightGray,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            PlaceSearchInput(
                              controller: _destinationController,
                              focusNode: _destinationFocusNode,
                              hintText: 'Nhập điểm đến...',
                              onClear: () {
                                _destinationController.clear();
                                provider.clearDestination();
                              },
                              onChanged: (value) {
                                // Handled by listener
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Search Results
                Expanded(
                  child: _buildSearchResults(provider),
                ),

                // Bottom Action Button
                if (provider.canOpenMap)
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _openMap,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.accentBlue,
                          foregroundColor: AppTheme.primaryWhite,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Xem bản đồ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSearchResults(PlaceSearchProvider provider) {
    if (provider.isSearching) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              'Đang tìm kiếm...',
              style: AppTheme.body2,
            ),
          ],
        ),
      );
    }

    if (provider.searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              provider.searchQuery.isEmpty ? Icons.search : Icons.location_off,
              size: 64,
              color: AppTheme.lightGray,
            ),
            const SizedBox(height: 16),
            Text(
              provider.searchQuery.isEmpty
                  ? 'Nhập từ khóa để tìm kiếm địa điểm'
                  : 'Không tìm thấy địa điểm nào',
              style: AppTheme.body2,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: provider.searchResults.length,
      itemBuilder: (context, index) {
        final place = provider.searchResults[index];
        return PlaceItem(
          place: place,
          onTap: () => _selectPlace(place),
        );
      },
    );
  }
}
