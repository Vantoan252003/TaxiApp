import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/services/location_cache_service.dart';
import '../../../core/providers/place_provider.dart';
import '../../../data/models/place_model.dart';
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
      setState(() {
        _originController.text = cachedAddress ?? "Vị trí hiện tại";
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
      setState(() {
        _originController.text = address ?? "Vị trí hiện tại";
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
            _navigateToRideScreen();
          }
        } else {
          _originController.text = place.name;
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
                });
              },
              onDestinationPlaceSelected: (place) {
                setState(() {
                  _destinationController.text = place.name;
                });
                if (_originController.text.isNotEmpty &&
                    _originController.text.trim().isNotEmpty) {
                  _navigateToRideScreen();
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
