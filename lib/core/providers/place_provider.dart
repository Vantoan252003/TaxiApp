import 'package:flutter/foundation.dart';
import '../../data/models/place_model.dart';
import '../../domain/usecase/place_usecases.dart';
import '../services/service_locator.dart';

enum PlaceSearchState { initial, loading, loaded, error }

class PlaceProvider extends ChangeNotifier {
  PlaceSearchState _state = PlaceSearchState.initial;
  String? _errorMessage;
  List<AutocompleteData> _searchResults = [];
  String _lastQuery = '';

  // Use cases
  SearchPlacesUseCase? _searchPlacesUseCase;

  PlaceProvider();

  // Lazy initialization of use case
  SearchPlacesUseCase get _getSearchPlacesUseCase {
    try {
      _searchPlacesUseCase ??=
          ServiceLocator.instance.get<SearchPlacesUseCase>();
      return _searchPlacesUseCase!;
    } catch (e) {
      throw Exception('Failed to initialize SearchPlacesUseCase: $e');
    }
  }

  // Getters
  PlaceSearchState get state => _state;
  String? get errorMessage => _errorMessage;
  List<AutocompleteData> get searchResults => _searchResults;
  String get lastQuery => _lastQuery;
  bool get isLoading => _state == PlaceSearchState.loading;
  bool get hasResults => _searchResults.isNotEmpty;

  // Search places with autocomplete
  Future<void> searchPlaces(String query) async {
    if (query.trim().isEmpty) {
      _setState(PlaceSearchState.initial);
      _searchResults = [];
      _lastQuery = '';
      return;
    }

    // Don't search if query is too short
    if (query.trim().length < 2) {
      _setState(PlaceSearchState.initial);
      _searchResults = [];
      _lastQuery = query;
      return;
    }

    // Don't search if it's the same query
    if (_lastQuery == query.trim()) {
      return;
    }

    _setState(PlaceSearchState.loading);
    _lastQuery = query.trim();

    try {
      final response = await _getSearchPlacesUseCase.execute(query.trim());

      if (response.success) {
        _searchResults = response.data;
        _setState(PlaceSearchState.loaded);
      } else {
        _setError('Search failed: ${response.message}');
      }
    } catch (e) {
      _setError(e.toString());
    }
  }

  // Clear search results
  void clearSearch() {
    _setState(PlaceSearchState.initial);
    _searchResults = [];
    _lastQuery = '';
  }

  // Get place by index
  AutocompleteData? getPlaceAt(int index) {
    if (index >= 0 && index < _searchResults.length) {
      return _searchResults[index];
    }
    return null;
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    if (_state == PlaceSearchState.error) {
      _setState(PlaceSearchState.initial);
    }
  }

  // Private methods
  void _setState(PlaceSearchState newState) {
    _state = newState;
    _errorMessage = null;
    notifyListeners();
  }

  void _setError(String error) {
    _state = PlaceSearchState.error;
    _errorMessage = error;
    _searchResults = [];
    notifyListeners();
  }
}
