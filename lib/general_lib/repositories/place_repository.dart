import 'package:flutter/foundation.dart';
import '../models/place_model.dart';
import '../services/vietmap_service.dart';

abstract class IPlaceRepository {
  Future<List<PlaceModel>> searchPlaces(String query);
  Future<String?> getCurrentAddress();
  Future<String?> getAddressFromCoordinates(double latitude, double longitude);
  Future<PlaceModel?> getPlaceDetails(String placeId);
}

class PlaceRepository implements IPlaceRepository {
  const PlaceRepository();

  @override
  Future<List<PlaceModel>> searchPlaces(String query) async {
    try {
      final results = await VietMapService.searchPlaces(query);
      debugPrint('Repository: Raw results count: ${results.length}');

      final placeModels = results.map((map) {
        debugPrint('Repository: Converting map: $map');
        return PlaceModel.fromMap(map);
      }).toList();

      debugPrint('Repository: Converted to ${placeModels.length} PlaceModels');
      return placeModels;
    } catch (e) {
      debugPrint('Repository error: $e');
      return const [];
    }
  }

  @override
  Future<String?> getCurrentAddress() async {
    try {
      return await VietMapService.getCurrentAddress();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<String?> getAddressFromCoordinates(
      double latitude, double longitude) async {
    try {
      return await VietMapService.getAddressFromCoordinates(
          latitude, longitude);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<PlaceModel?> getPlaceDetails(String placeId) async {
    try {
      final details = await VietMapService.getPlaceDetails(placeId);
      if (details != null) {
        return PlaceModel.fromMap(details);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
