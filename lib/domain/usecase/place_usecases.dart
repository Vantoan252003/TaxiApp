import '../../data/models/place_model.dart';
import '../../data/repositories/place_repository.dart';

// Use case for searching places
class SearchPlacesUseCase {
  final PlaceRepository _repository;

  SearchPlacesUseCase(this._repository);

  Future<AutocompleteResponse> execute(String query) async {
    if (query.trim().isEmpty) {
      return AutocompleteResponse(
        success: true,
        message: 'Empty query',
        data: [],
        timestamp: DateTime.now().toIso8601String(),
      );
    }

    return await _repository.searchPlaces(query.trim());
  }
}

// Use case for reverse geocoding
class ReverseGeocodingUseCase {
  final PlaceRepository _repository;

  ReverseGeocodingUseCase(this._repository);

  Future<ReverseGeocodingResponse> execute({
    required double lat,
    required double lng,
  }) async {
    return await _repository.reverseGeocoding(lat: lat, lng: lng);
  }
}

// Use case for getting place details
class GetPlaceDetailUseCase {
  final PlaceRepository _repository;

  GetPlaceDetailUseCase(this._repository);

  Future<PlaceDetailResponse> execute(String refId) async {
    if (refId.trim().isEmpty) {
      throw Exception('RefId cannot be empty');
    }

    return await _repository.getPlaceDetail(refId.trim());
  }
}
