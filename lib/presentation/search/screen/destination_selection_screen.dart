import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';
import '../../../core/services/location_cache_service.dart';
import '../../../core/services/location_service.dart';
import '../../../core/services/service_locator.dart';
import '../../../core/providers/place_provider.dart';
import '../../../data/models/place_model.dart';
import '../../../domain/usecase/place_usecases.dart';
import '../widgets/index.dart';
import '../../booking/page/booking_screen.dart';

class DestinationSelectionScreen extends StatefulWidget {
  const DestinationSelectionScreen({super.key});

  @override
  State<DestinationSelectionScreen> createState() =>
      _DestinationSelectionScreenState();
}

class _DestinationSelectionScreenState
    extends State<DestinationSelectionScreen> {
  final TextEditingController _originController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isDestinationFocused = false;
  bool _isOriginFocused = false;
  bool _isLoadingCurrentLocation = true;
  bool _isGettingCurrentLocation = false;
  String _lastFocusedField = 'origin';
  String? _originRefId; // Store origin refId when user selects origin place
  String _initialOriginText =
      ''; // Store initial origin text to check if it was modified

  @override
  void initState() {
    super.initState();
    _loadCurrentLocation();
  }

  Future<void> _loadCurrentLocation() async {
    setState(() {
      _isLoadingCurrentLocation = true;
    });

    try {
      final cachedAddress = await LocationCacheService.getCurrentAddress();
      final initialText = cachedAddress ?? "Vị trí hiện tại";
      setState(() {
        _originController.text = initialText;
        _initialOriginText = initialText; // Store initial text
      });
    } finally {
      setState(() {
        _isLoadingCurrentLocation = false;
      });
    }
  }

  Future<void> _refreshCurrentLocation() async {
    setState(() {
      _isGettingCurrentLocation = true;
    });

    try {
      final address =
          await LocationCacheService.updateAndCacheCurrentLocation();
      final newText = address ?? "Vị trí hiện tại";
      setState(() {
        _originController.text = newText;
        _initialOriginText = newText; // Update initial text when refreshing
      });
    } finally {
      setState(() {
        _isGettingCurrentLocation = false;
      });
    }
  }

  @override
  void dispose() {
    _originController.dispose();
    _destinationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _swapLocations() {
    final temp = _originController.text;
    _originController.text = _destinationController.text;
    _destinationController.text = temp;
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  String _formatDistance(double distance) {
    if (distance < 1.0) {
      final meters = (distance * 1000).round();
      return '${meters}m';
    } else {
      final km = (distance * 10).round() / 10;
      return '${km}km';
    }
  }

  void _navigateToRideScreen() {
    if (_originController.text.isNotEmpty &&
        _originController.text.trim().isNotEmpty &&
        _destinationController.text.isNotEmpty &&
        _destinationController.text.trim().isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RideScreen(
            origin: _originController.text.trim(),
            destination: _destinationController.text.trim(),
          ),
        ),
      );
    }
  }

  Future<void> _navigateToRideScreenWithPlaceDetails(
      String destinationRefId) async {
    if (_originController.text.isNotEmpty &&
        _originController.text.trim().isNotEmpty &&
        _destinationController.text.isNotEmpty &&
        _destinationController.text.trim().isNotEmpty) {
      try {
        // Show loading indicator
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        );

        // Get origin refId from stored value or search results
        String? originRefId = _originRefId;
        if (originRefId == null && context.mounted) {
          final placeProvider =
              Provider.of<PlaceProvider>(context, listen: false);
          for (final place in placeProvider.searchResults) {
            if (place.name == _originController.text.trim()) {
              originRefId = place.refId;
              break;
            }
          }
        }

        final getPlaceDetailUseCase =
            ServiceLocator.instance.get<GetPlaceDetailUseCase>();

        LatLng? originLatLng;
        LatLng? destinationLatLng;

        // Get destination coordinates
        final destinationResponse =
            await getPlaceDetailUseCase.execute(destinationRefId);
        if (destinationResponse.success &&
            destinationResponse.data.isNotEmpty) {
          final destinationDetail = destinationResponse.data.first;
          destinationLatLng =
              LatLng(destinationDetail.lat, destinationDetail.lng);
        }

        // Get origin coordinates based on whether user modified the input
        if (_originController.text.trim() == _initialOriginText.trim()) {
          // User didn't modify origin - use current GPS location
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
        } else if (originRefId != null && originRefId.isNotEmpty) {
          // User selected a place - get coordinates from API
          try {
            final originResponse =
                await getPlaceDetailUseCase.execute(originRefId);
            if (originResponse.success && originResponse.data.isNotEmpty) {
              final originDetail = originResponse.data.first;
              originLatLng = LatLng(originDetail.lat, originDetail.lng);
              print(
                  'DEBUG: Origin coordinates from API: ${originDetail.lat}, ${originDetail.lng}');
            }
          } catch (e) {
            print('DEBUG: Error getting origin coordinates: $e');
            // Use default origin coordinates as fallback
            originLatLng = const LatLng(10.762317, 106.654551);
          }
        } else {
          // Check if origin is current location
          if (_originController.text.trim() == "Vị trí hiện tại") {
            print(
                'DEBUG: Origin is current location, getting current coordinates...');
            try {
              // Get current location coordinates from cache
              final cachedCoords =
                  await LocationCacheService.getCachedCoordinates();
              if (cachedCoords != null) {
                originLatLng =
                    LatLng(cachedCoords['lat']!, cachedCoords['lng']!);
                print(
                    'DEBUG: Current location coordinates from cache: ${cachedCoords['lat']}, ${cachedCoords['lng']}');
              } else {
                print(
                    'DEBUG: Could not get current position from cache, using default coordinates');
                originLatLng = const LatLng(10.762317, 106.654551);
              }
            } catch (e) {
              print('DEBUG: Error getting current location: $e');
              originLatLng = const LatLng(10.762317, 106.654551);
            }
          } else {
            print(
                'DEBUG: No origin RefId available, using default coordinates');
            originLatLng = const LatLng(10.762317, 106.654551);
          }
        }

        // Hide loading indicator
        if (context.mounted) {
          Navigator.pop(context);
        }
        if (destinationLatLng != null) {
          // Navigate to ride screen with both coordinates
          print('DEBUG: Navigating to RideScreen with both coordinates');
          if (context.mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RideScreen(
                  origin: _originController.text.trim(),
                  destination: _destinationController.text.trim(),
                  originLatLng: originLatLng,
                  destinationLatLng: destinationLatLng,
                ),
              ),
            );
          }
        } else {
          print('DEBUG: Failed to get destination coordinates, using fallback');
          // Fallback to regular navigation if destination API fails
          _navigateToRideScreen();
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
        _navigateToRideScreen();
      }
    }
  }

  Widget _buildCurrentLocationButton() {
    return InkWell(
      onTap: _isGettingCurrentLocation ? null : _refreshCurrentLocation,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Icon(Icons.my_location, color: Colors.blue[600], size: 20),
            const SizedBox(width: 12),
            if (_isGettingCurrentLocation) ...[
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              const SizedBox(width: 12),
              Text(
                'Đang lấy vị trí hiện tại...',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ] else ...[
              const Text(
                'Sử dụng vị trí hiện tại',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults(PlaceProvider placeProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Kết quả tìm kiếm",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        ...placeProvider.searchResults
            .map((place) => _buildSearchResultItem(place)),
      ],
    );
  }

  Widget _buildSearchResultItem(AutocompleteData place) {
    return InkWell(
      onTap: () {
        if (_lastFocusedField == 'destination') {
          _destinationController.text = place.name;
          setState(() {
            _isDestinationFocused = false;
            _isOriginFocused = false;
          });
          if (_originController.text.isNotEmpty &&
              _originController.text.trim().isNotEmpty) {
            _navigateToRideScreenWithPlaceDetails(place.refId);
          }
        } else {
          _originController.text = place.name;
          _originRefId = place.refId; // Store origin refId
          setState(() {
            _isDestinationFocused = false;
            _isOriginFocused = false;
          });
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              _isDestinationFocused = true;
            });
            _scrollToTop();
          });
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 40,
              child: Column(
                children: [
                  Icon(Icons.location_on,
                      color: Colors.grey.shade600, size: 16),
                  if (place.distance != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      _formatDistance(place.distance),
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    place.display,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(Icons.bookmark_border, color: Colors.grey.shade400, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Đang tìm kiếm",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Icon(Icons.search, color: Colors.grey.shade600, size: 20),
              const SizedBox(width: 12),
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              const SizedBox(width: 12),
              Text(
                'Đang tìm kiếm...',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Bạn muốn đi đâu?",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content:
                        Text('Tính năng chọn từ bản đồ sẽ được phát triển')),
              );
            },
            child: const Text(
              "Chọn từ bản đồ",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LocationInputSection(
              originController: _originController,
              destinationController: _destinationController,
              isDestinationFocused: _isDestinationFocused,
              isLoadingOrigin: _isLoadingCurrentLocation,
              onDestinationTap: () {
                setState(() {
                  _isDestinationFocused = true;
                  _isOriginFocused = false;
                });
              },
              onSwapLocations: _swapLocations,
              onAddDestination: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content:
                          Text('Tính năng thêm điểm đến sẽ được phát triển')),
                );
              },
              onOriginPlaceSelected: (place) {
                setState(() {
                  _originController.text = place.name;
                  _originRefId = place.refId; // Store refId
                });
              },
              onDestinationPlaceSelected: (place) {
                setState(() {
                  _destinationController.text = place.name;
                });
                if (_originController.text.isNotEmpty &&
                    _originController.text.trim().isNotEmpty) {
                  _navigateToRideScreenWithPlaceDetails(place.refId);
                }
              },
              onOriginFocusChanged: (focused) {
                setState(() {
                  _isOriginFocused = focused;
                  _isDestinationFocused = false;
                  if (focused) _lastFocusedField = 'origin';
                });
              },
              onDestinationFocusChanged: (focused) {
                setState(() {
                  _isDestinationFocused = focused;
                  _isOriginFocused = false;
                  if (focused) _lastFocusedField = 'destination';
                });
              },
              onGetCurrentLocation: _refreshCurrentLocation,
            ),
            const SizedBox(height: 16),
            QuickActionsSection(
              onAddHome: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đã chọn: Thêm nhà')),
                );
              },
              onAddWork: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đã chọn: Thêm công ty')),
                );
              },
              onAddPlace: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đã chọn: Thêm địa điểm')),
                );
              },
            ),
            const SizedBox(height: 24),
            Consumer<PlaceProvider>(
              builder: (context, placeProvider, child) {
                // Show search results
                if (placeProvider.hasResults) {
                  return _buildSearchResults(placeProvider);
                }

                // Show loading state
                if (placeProvider.isLoading) {
                  return _buildLoadingState();
                }

                // Show current location button + popular destinations
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Current location button (chỉ hiện khi origin trống hoặc đang loading)
                    if (_originController.text.isEmpty ||
                        _originController.text == "Vị trí hiện tại")
                      _buildCurrentLocationButton(),

                    // Popular destinations
                    PopularDestinationsSection(
                      onDestinationSelected: (destination) {
                        _destinationController.text = destination;
                        setState(() {
                          _isDestinationFocused = false;
                        });
                        if (_originController.text.isNotEmpty &&
                            _originController.text.trim().isNotEmpty) {
                          _navigateToRideScreen();
                        }
                      },
                      onGetCurrentLocation: _refreshCurrentLocation,
                      showCurrentLocation:
                          false, // Tắt vì đã có button riêng ở trên
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
