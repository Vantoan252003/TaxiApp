import '../models/place_model.dart';
import '../repositories/place_repository.dart';

class SearchPlacesUseCase {
  final IPlaceRepository _repository;

  const SearchPlacesUseCase(this._repository);

  Future<List<PlaceModel>> execute(String query) async {
    if (query.trim().isEmpty) return const [];
    if (query.trim().length < 2) return const [];
    
    return await _repository.searchPlaces(query.trim());
  }
}

class GetCurrentAddressUseCase {
  final IPlaceRepository _repository;

  const GetCurrentAddressUseCase(this._repository);

  Future<String?> execute() async {
    return await _repository.getCurrentAddress();
  }
}

class GetAddressFromCoordinatesUseCase {
  final IPlaceRepository _repository;

  const GetAddressFromCoordinatesUseCase(this._repository);

  Future<String?> execute(double latitude, double longitude) async {
    return await _repository.getAddressFromCoordinates(latitude, longitude);
  }
}

class GetPlaceDetailsUseCase {
  final IPlaceRepository _repository;

  const GetPlaceDetailsUseCase(this._repository);

  Future<PlaceModel?> execute(String placeId) async {
    if (placeId.isEmpty) return null;
    
    return await _repository.getPlaceDetails(placeId);
  }
} 