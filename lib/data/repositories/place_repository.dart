import '../models/place_model.dart';
import '../../core/services/location_service.dart';

abstract class PlaceRepository {
  Future<AutocompleteResponse> searchPlaces(String query);
  Future<ReverseGeocodingResponse> reverseGeocoding({
    required double lat,
    required double lng,
  });
  Future<PlaceDetailResponse> getPlaceDetail(String refId);
}

class PlaceRepositoryImpl implements PlaceRepository {
  @override
  Future<AutocompleteResponse> searchPlaces(String query) async {
    return await LocationService.searchPlaces(query);
  }

  @override
  Future<ReverseGeocodingResponse> reverseGeocoding({
    required double lat,
    required double lng,
  }) async {
    return await LocationService.reverseGeocoding(lat: lat, lng: lng);
  }

  @override
  Future<PlaceDetailResponse> getPlaceDetail(String refId) async {
    return await LocationService.getPlaceDetail(refId);
  }
}
