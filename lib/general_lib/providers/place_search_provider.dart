import 'package:flutter/foundation.dart';
import '../models/place_model.dart';
import '../usecases/place_usecases.dart';
import '../services/location_cache_service.dart';

class PlaceSearchProvider extends ChangeNotifier {
  final SearchPlacesUseCase _searchPlacesUseCase;
  final GetCurrentAddressUseCase _getCurrentAddressUseCase;

  PlaceSearchProvider({
    required SearchPlacesUseCase searchPlacesUseCase,
    required GetCurrentAddressUseCase getCurrentAddressUseCase,
  })  : _searchPlacesUseCase = searchPlacesUseCase,
        _getCurrentAddressUseCase = getCurrentAddressUseCase;

  // State
  String _currentLocation = '';
  PlaceModel? _selectedOrigin;
  PlaceModel? _selectedDestination;
  List<PlaceModel> _searchResults = const [];
  bool _isLoadingLocation = false;
  bool _isSearching = false;
  String _searchQuery = '';
  bool _isSearchingOrigin = false;

  // Getters
  String get currentLocation => _currentLocation;
  PlaceModel? get selectedOrigin => _selectedOrigin;
  PlaceModel? get selectedDestination => _selectedDestination;
  List<PlaceModel> get searchResults => _searchResults;
  bool get isLoadingLocation => _isLoadingLocation;
  bool get isSearching => _isSearching;
  String get searchQuery => _searchQuery;
  bool get isSearchingOrigin => _isSearchingOrigin;
  bool get canOpenMap =>
      _selectedOrigin != null && _selectedDestination != null;

  // Actions
  Future<void> getCurrentLocation() async {
    _isLoadingLocation = true;
    notifyListeners();

    try {
      // Try to get cached location first
      final cachedLocation = await LocationCacheService.getCachedLocation();
      if (cachedLocation != null) {
        _currentLocation =
            cachedLocation['address'] ?? 'Không thể lấy vị trí hiện tại';
        _isLoadingLocation = false;
        notifyListeners();
        return;
      }

      // If no cache, get fresh location
      final address = await _getCurrentAddressUseCase.execute();
      _currentLocation = address ?? 'Không thể lấy vị trí hiện tại';

      // Cache the new location
      if (address != null) {
        await LocationCacheService.cacheLocation(address, 0, 0);
      }
    } catch (e) {
      _currentLocation = 'Lỗi khi lấy vị trí hiện tại';
    } finally {
      _isLoadingLocation = false;
      notifyListeners();
    }
  }

  Future<void> searchPlaces(String query, {bool isOrigin = false}) async {
    debugPrint('Searching places: "$query", isOrigin: $isOrigin');

    if (query.trim().isEmpty || query.trim().length < 2) {
      debugPrint('Query too short, clearing results');
      _searchResults = const [];
      _searchQuery = query;
      _isSearchingOrigin = isOrigin;
      notifyListeners();
      return;
    }

    _isSearching = true;
    _isSearchingOrigin = isOrigin;
    _searchQuery = query;
    notifyListeners();

    try {
      final results = await _searchPlacesUseCase.execute(query);
      debugPrint('Search results: ${results.length} items');
      _searchResults = results;
    } catch (e) {
      debugPrint('Search error: $e');
      _searchResults = const [];
    } finally {
      _isSearching = false;
      notifyListeners();
    }
  }

  void selectOrigin(PlaceModel place) {
    _selectedOrigin = place;
    notifyListeners();
  }

  void selectDestination(PlaceModel place) {
    _selectedDestination = place;
    notifyListeners();
  }

  void useCurrentLocationAsOrigin() {
    if (_currentLocation.isNotEmpty) {
      _selectedOrigin = PlaceModel(
        id: 'current_location',
        name: 'Vị trí hiện tại',
        display: _currentLocation,
        address: _currentLocation,
      );
      notifyListeners();
    }
  }

  void clearSearch() {
    _searchResults = const [];
    _searchQuery = '';
    notifyListeners();
  }

  void clearOrigin() {
    _selectedOrigin = null;
    notifyListeners();
  }

  void clearDestination() {
    _selectedDestination = null;
    notifyListeners();
  }

  void reset() {
    _selectedOrigin = null;
    _selectedDestination = null;
    _searchResults = const [];
    _searchQuery = '';
    notifyListeners();
  }
}
