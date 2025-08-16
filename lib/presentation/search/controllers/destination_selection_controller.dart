import 'package:flutter/material.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';
import '../../../core/services/location_cache_service.dart';
import '../../../core/services/location_service.dart';
import '../../../core/services/service_locator.dart';
import '../../../core/services/fare_estimate_service.dart';
import '../../../core/services/recent_destinations_service.dart';
import '../../../core/services/driver_service.dart';
import '../../../core/providers/place_provider.dart';
import '../../../data/models/fare_estimate_model.dart';
import '../../../data/models/driver_model.dart';
import '../../../domain/usecase/place_usecases.dart';
import '../../booking/page/booking_screen.dart';

class DestinationSelectionController extends ChangeNotifier {
  final TextEditingController originController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  bool _isDestinationFocused = false;
  bool _isOriginFocused = false;
  bool _isLoadingCurrentLocation = true;
  bool _isGettingCurrentLocation = false;
  bool _isLoadingDrivers = false;
  String _lastFocusedField = 'origin';
  String? _originRefId;
  String _initialOriginText = '';
  List<DriverModel> _nearbyDrivers = [];

  // Getters
  bool get isDestinationFocused => _isDestinationFocused;
  bool get isOriginFocused => _isOriginFocused;
  bool get isLoadingCurrentLocation => _isLoadingCurrentLocation;
  bool get isGettingCurrentLocation => _isGettingCurrentLocation;
  bool get isLoadingDrivers => _isLoadingDrivers;
  String get lastFocusedField => _lastFocusedField;
  String? get originRefId => _originRefId;
  String get initialOriginText => _initialOriginText;
  List<DriverModel> get nearbyDrivers => _nearbyDrivers;

  @override
  void dispose() {
    originController.dispose();
    destinationController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  Future<void> loadCurrentLocation() async {
    _isLoadingCurrentLocation = true;
    notifyListeners();

    try {
      final cachedAddress = await LocationCacheService.getCurrentAddress();
      final initialText = cachedAddress ?? "Vị trí hiện tại";
      originController.text = initialText;
      _initialOriginText = initialText;
    } finally {
      _isLoadingCurrentLocation = false;
      notifyListeners();
    }
  }

  Future<void> refreshCurrentLocation() async {
    _isGettingCurrentLocation = true;
    notifyListeners();

    try {
      final address =
          await LocationCacheService.updateAndCacheCurrentLocation();
      final newText = address ?? "Vị trí hiện tại";
      originController.text = newText;
      _initialOriginText = newText;
    } finally {
      _isGettingCurrentLocation = false;
      notifyListeners();
    }
  }

  void swapLocations() {
    final temp = originController.text;
    originController.text = destinationController.text;
    destinationController.text = temp;
    notifyListeners();
  }

  void scrollToTop() {
    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  String formatDistance(double distance) {
    if (distance < 1.0) {
      final meters = (distance * 1000).round();
      return '${meters}m';
    } else {
      final km = (distance * 10).round() / 10;
      return '${km}km';
    }
  }

  void setDestinationFocused(bool focused) {
    _isDestinationFocused = focused;
    _isOriginFocused = false;
    if (focused) _lastFocusedField = 'destination';
    notifyListeners();
  }

  void setOriginFocused(bool focused) {
    _isOriginFocused = focused;
    _isDestinationFocused = false;
    if (focused) _lastFocusedField = 'origin';
    notifyListeners();
  }

  void setOriginRefId(String? refId) {
    _originRefId = refId;
  }

  void navigateToRideScreen(BuildContext context) {
    if (originController.text.isNotEmpty &&
        originController.text.trim().isNotEmpty &&
        destinationController.text.isNotEmpty &&
        destinationController.text.trim().isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RideScreen(
            origin: originController.text.trim(),
            destination: destinationController.text.trim(),
          ),
        ),
      );
    }
  }

  Future<void> navigateToRideScreenWithCoordinates(
    BuildContext context,
    LatLng destinationLatLng,
  ) async {
    if (originController.text.isNotEmpty &&
        originController.text.trim().isNotEmpty &&
        destinationController.text.isNotEmpty &&
        destinationController.text.trim().isNotEmpty) {
      try {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        );

        LatLng? originLatLng;

        if (originController.text.trim() == _initialOriginText.trim()) {
          try {
            final currentPosition = await LocationService.getCurrentPosition();
            if (currentPosition != null) {
              originLatLng =
                  LatLng(currentPosition.latitude, currentPosition.longitude);
            } else {
              originLatLng = const LatLng(10.762317, 106.654551);
            }
          } catch (e) {
            originLatLng = const LatLng(10.762317, 106.654551);
          }
        } else if (_originRefId != null && _originRefId!.isNotEmpty) {
          // User selected a place - get coordinates from API
          try {
            final getPlaceDetailUseCase =
                ServiceLocator.instance.get<GetPlaceDetailUseCase>();
            final originResponse =
                await getPlaceDetailUseCase.execute(_originRefId!);
            if (originResponse.success && originResponse.data.isNotEmpty) {
              final originDetail = originResponse.data.first;
              originLatLng = LatLng(originDetail.lat, originDetail.lng);
            }
          } catch (e) {
            originLatLng = null;
          }
        } else {
          if (originController.text.trim() == "Vị trí hiện tại") {
            try {
              final cachedCoords =
                  await LocationCacheService.getCachedCoordinates();
              if (cachedCoords != null) {
                originLatLng =
                    LatLng(cachedCoords['lat']!, cachedCoords['lng']!);
              } else {
                originLatLng = null;
              }
            } catch (e) {
              originLatLng = null;
            }
          } else {
            originLatLng = null;
          }
        }

        FareEstimateResponse? fareEstimate;
        if (originLatLng != null) {
          fareEstimate = await FareEstimateService.getFareEstimate(
            pickupLat: originLatLng.latitude,
            pickupLng: originLatLng.longitude,
            destLat: destinationLatLng.latitude,
            destLng: destinationLatLng.longitude,
          );
        }

        // Hide loading indicator
        if (context.mounted) {
          Navigator.pop(context);
        }

        // Find nearby drivers before navigating
        List<DriverModel> nearbyDrivers = [];
        if (originLatLng != null) {
          try {
            nearbyDrivers = await DriverService.findNearbyMotorcycles(
              lat: originLatLng.latitude,
              lng: originLatLng.longitude,
              radiusMeters: 3000,
            );
          } catch (e) {
            // Silently handle error
          }
        }

        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RideScreen(
                origin: originController.text.trim(),
                destination: destinationController.text.trim(),
                originLatLng: originLatLng,
                destinationLatLng: destinationLatLng,
                fareEstimate: fareEstimate,
                nearbyDrivers: nearbyDrivers,
              ),
            ),
          );
        }
      } catch (e) {
        // Hide loading indicator
        if (context.mounted) {
          Navigator.pop(context);
        }

        // Show error message
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Không thể lấy thông tin địa điểm: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
        navigateToRideScreen(context);
      }
    }
  }

  Future<void> navigateToRideScreenWithPlaceDetails(
    BuildContext context,
    String destinationRefId,
    PlaceProvider placeProvider,
  ) async {
    if (originController.text.isNotEmpty &&
        originController.text.trim().isNotEmpty &&
        destinationController.text.isNotEmpty &&
        destinationController.text.trim().isNotEmpty) {
      try {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        );

        String? originRefId = _originRefId;
        if (originRefId == null && context.mounted) {
          for (final place in placeProvider.searchResults) {
            if (place.name == originController.text.trim()) {
              originRefId = place.refId;
              break;
            }
          }
        }

        final getPlaceDetailUseCase =
            ServiceLocator.instance.get<GetPlaceDetailUseCase>();

        LatLng? originLatLng;
        LatLng? destinationLatLng;

        final destinationResponse =
            await getPlaceDetailUseCase.execute(destinationRefId);
        if (destinationResponse.success &&
            destinationResponse.data.isNotEmpty) {
          final destinationDetail = destinationResponse.data.first;
          destinationLatLng =
              LatLng(destinationDetail.lat, destinationDetail.lng);
          final destination = RecentDestination(
            name: destinationDetail.name,
            address: destinationDetail.address,
            latitude: destinationDetail.lat,
            longitude: destinationDetail.lng,
            timestamp: DateTime.now(),
          );
          await RecentDestinationsService.addRecentDestination(destination);
        }

        // Get origin coordinates based on whether user modified the input
        if (originController.text.trim() == _initialOriginText.trim()) {
          try {
            final currentPosition = await LocationService.getCurrentPosition();
            if (currentPosition != null) {
              originLatLng =
                  LatLng(currentPosition.latitude, currentPosition.longitude);
            } else {
              originLatLng = null;
            }
          } catch (e) {
            originLatLng = null;
          }
        } else if (originRefId != null && originRefId.isNotEmpty) {
          try {
            final originResponse =
                await getPlaceDetailUseCase.execute(originRefId);
            if (originResponse.success && originResponse.data.isNotEmpty) {
              final originDetail = originResponse.data.first;
              originLatLng = LatLng(originDetail.lat, originDetail.lng);
            }
          } catch (e) {
            originLatLng = null;
          }
        } else {
          if (originController.text.trim() == "Vị trí hiện tại") {
            try {
              final cachedCoords =
                  await LocationCacheService.getCachedCoordinates();
              if (cachedCoords != null) {
                originLatLng =
                    LatLng(cachedCoords['lat']!, cachedCoords['lng']!);
              } else {
                originLatLng = null;
              }
            } catch (e) {
              originLatLng = null;
            }
          } else {
            originLatLng = null;
          }
        }

        FareEstimateResponse? fareEstimate;
        if (originLatLng != null && destinationLatLng != null) {
          fareEstimate = await FareEstimateService.getFareEstimate(
            pickupLat: originLatLng.latitude,
            pickupLng: originLatLng.longitude,
            destLat: destinationLatLng.latitude,
            destLng: destinationLatLng.longitude,
          );
        }

        // Hide loading indicator
        if (context.mounted) {
          Navigator.pop(context);
        }

        if (destinationLatLng != null) {
          // Find nearby drivers before navigating
          List<DriverModel> nearbyDrivers = [];
          if (originLatLng != null) {
            try {
              nearbyDrivers = await DriverService.findNearbyMotorcycles(
                lat: originLatLng.latitude,
                lng: originLatLng.longitude,
                radiusMeters: 3000,
              );
            } catch (e) {
              // Silently handle error
            }
          }

          if (context.mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RideScreen(
                  origin: originController.text.trim(),
                  destination: destinationController.text.trim(),
                  originLatLng: originLatLng,
                  destinationLatLng: destinationLatLng,
                  fareEstimate: fareEstimate,
                  nearbyDrivers: nearbyDrivers,
                ),
              ),
            );
          }
        } else {
          navigateToRideScreen(context);
        }
      } catch (e) {
        // Hide loading indicator
        if (context.mounted) {
          Navigator.pop(context);
        }

        // Show error message
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Không thể lấy thông tin địa điểm: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
        navigateToRideScreen(context);
      }
    }
  }

  void onOriginPlaceSelected(dynamic place) {
    originController.text = place.name;
    _originRefId = place.refId;
    notifyListeners();
  }

  void onDestinationPlaceSelected(dynamic place) {
    destinationController.text = place.name;
    notifyListeners();
  }

  void onSearchResultTap(dynamic place) {
    if (_lastFocusedField == 'destination') {
      destinationController.text = place.name;
      setDestinationFocused(false);
    } else {
      originController.text = place.name;
      _originRefId = place.refId;
      setOriginFocused(false);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setDestinationFocused(true);
        scrollToTop();
      });
    }
  }

  /// Find nearby drivers based on current location
  Future<void> findNearbyDrivers() async {
    _isLoadingDrivers = true;
    notifyListeners();

    try {
      final currentPosition = await LocationService.getCurrentPosition();
      if (currentPosition != null) {
        final drivers = await DriverService.findNearbyMotorcycles(
          lat: currentPosition.latitude,
          lng: currentPosition.longitude,
          radiusMeters: 3000,
        );
        _nearbyDrivers = drivers;
      }
    } catch (e) {
      _nearbyDrivers = [];
    } finally {
      _isLoadingDrivers = false;
      notifyListeners();
    }
  }

  Future<void> findNearbyDriversAtLocation(double lat, double lng) async {
    _isLoadingDrivers = true;
    notifyListeners();

    try {
      final drivers = await DriverService.findNearbyMotorcycles(
        lat: lat,
        lng: lng,
        radiusMeters: 3000,
      );
      _nearbyDrivers = drivers;
    } catch (e) {
      _nearbyDrivers = [];
    } finally {
      _isLoadingDrivers = false;
      notifyListeners();
    }
  }

  /// Clear nearby drivers list
  void clearNearbyDrivers() {
    _nearbyDrivers = [];
    notifyListeners();
  }
}
