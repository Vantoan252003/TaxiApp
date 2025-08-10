import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';
import '../../../core/providers/place_provider.dart';
import '../controllers/destination_selection_controller.dart';
import '../widgets/index.dart';

class DestinationSelectionScreen extends StatefulWidget {
  const DestinationSelectionScreen({super.key});

  @override
  State<DestinationSelectionScreen> createState() =>
      _DestinationSelectionScreenState();
}

class _DestinationSelectionScreenState
    extends State<DestinationSelectionScreen> {
  late final DestinationSelectionController _controller;

  @override
  void initState() {
    super.initState();
    _controller = DestinationSelectionController();
    _controller.loadCurrentLocation();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh dữ liệu điểm đi gần đây khi quay lại màn hình
    // Sẽ được xử lý tự động trong PopularDestinationsSection
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, child) {
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
                        content: Text(
                            'Tính năng chọn từ bản đồ sẽ được phát triển')),
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
            controller: _controller.scrollController,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LocationInputSection(
                  originController: _controller.originController,
                  destinationController: _controller.destinationController,
                  isDestinationFocused: _controller.isDestinationFocused,
                  isLoadingOrigin: _controller.isLoadingCurrentLocation,
                  onDestinationTap: () {
                    _controller.setDestinationFocused(true);
                  },
                  onSwapLocations: _controller.swapLocations,
                  onAddDestination: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              'Tính năng thêm điểm đến sẽ được phát triển')),
                    );
                  },
                  onOriginPlaceSelected: _controller.onOriginPlaceSelected,
                  onDestinationPlaceSelected: (place) {
                    _controller.onDestinationPlaceSelected(place);
                    if (_controller.originController.text.isNotEmpty &&
                        _controller.originController.text.trim().isNotEmpty) {
                      final placeProvider =
                          Provider.of<PlaceProvider>(context, listen: false);
                      _controller.navigateToRideScreenWithPlaceDetails(
                          context, place.refId, placeProvider);
                    }
                  },
                  onOriginFocusChanged: _controller.setOriginFocused,
                  onDestinationFocusChanged: _controller.setDestinationFocused,
                  onGetCurrentLocation: _controller.refreshCurrentLocation,
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
                      return SearchResultsSection(
                        searchResults: placeProvider.searchResults,
                        onPlaceSelected: (place) {
                          _controller.onSearchResultTap(place);
                          if (_controller.lastFocusedField == 'destination' &&
                              _controller.originController.text.isNotEmpty &&
                              _controller.originController.text
                                  .trim()
                                  .isNotEmpty) {
                            _controller.navigateToRideScreenWithPlaceDetails(
                                context, place.refId, placeProvider);
                          }
                        },
                        formatDistance: _controller.formatDistance,
                      );
                    }

                    // Show loading state
                    if (placeProvider.isLoading) {
                      return const LoadingStateWidget();
                    }

                    // Show current location button + popular destinations
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Current location button (chỉ hiện khi origin trống hoặc đang loading)
                        if (_controller.originController.text.isEmpty ||
                            _controller.originController.text ==
                                "Vị trí hiện tại")
                          CurrentLocationButton(
                            isGettingCurrentLocation:
                                _controller.isGettingCurrentLocation,
                            onTap: _controller.refreshCurrentLocation,
                          ),

                        // Popular destinations
                        PopularDestinationsSection(
                          onDestinationSelected:
                              (destination, latitude, longitude) {
                            _controller.destinationController.text =
                                destination;
                            _controller.setDestinationFocused(false);

                            if (_controller.originController.text.isNotEmpty &&
                                _controller.originController.text
                                    .trim()
                                    .isNotEmpty) {
                              // Nếu có thông tin lat/lng từ cache, sử dụng để tạo LatLng
                              if (latitude != null && longitude != null) {
                                final destinationLatLng =
                                    LatLng(latitude, longitude);
                                _controller.navigateToRideScreenWithCoordinates(
                                  context,
                                  destinationLatLng,
                                );
                              } else {
                                // Fallback về navigation thông thường nếu không có lat/lng
                                _controller.navigateToRideScreen(context);
                              }
                            }
                          },
                          onGetCurrentLocation:
                              _controller.refreshCurrentLocation,
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
      },
    );
  }
}
