import 'dart:math';
import 'package:flutter/material.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';
import 'package:vietmap_flutter_plugin/vietmap_flutter_plugin.dart';
import '../../general_lib/constants/app_theme.dart';
import '../../general_lib/constants/vietmap_constants.dart';

class RouteMapScreen extends StatefulWidget {
  final Map<String, dynamic> origin;
  final Map<String, dynamic> destination;

  const RouteMapScreen({
    super.key,
    required this.origin,
    required this.destination,
  });

  @override
  State<RouteMapScreen> createState() => _RouteMapScreenState();
}

class _RouteMapScreenState extends State<RouteMapScreen> {
  VietmapController? _mapController;
  bool _isMapReady = false;
  List<LatLng> _routePoints = [];
  double _distance = 0.0;
  int _duration = 0;
  String _selectedService = 'beBike';
  Line? _routeLine;
  Symbol? _originMarker;
  Symbol? _destinationMarker;

  final List<Map<String, dynamic>> _services = [
    {
      'id': 'beBike',
      'name': 'beBike',
      'icon': Icons.motorcycle,
      'subtitle': 'Giá siêu tốt',
      'price': '80.000₫',
      'color': AppTheme.accentBlue,
    },
    {
      'id': 'beCar',
      'name': 'beCar Plus',
      'icon': Icons.local_taxi,
      'subtitle': 'Xe 4 chỗ rộng rãi và thoải mái',
      'price': '217.000₫',
      'color': AppTheme.accentBlue,
    },
    {
      'id': 'beShare',
      'name': 'be Đi Chung 4',
      'icon': Icons.people,
      'subtitle': 'Ghép chuyến cùng 1 khách khác',
      'price': '180.000₫',
      'color': AppTheme.accentBlue,
    },
  ];


  @override
  void initState() {
    super.initState();
    _initializeVietMap();
  }

  void _initializeVietMap() {
    // Khởi tạo VietMap plugin
    Vietmap.getInstance(VietMapConstants.apiKey);
  }

  void _onMapCreated(VietmapController controller) {
    print('DEBUG: Map created');
    setState(() {
      _mapController = controller;
      _isMapReady = true;
    });

    // Đợi một chút để map hoàn toàn sẵn sàng
    Future.delayed(const Duration(milliseconds: 500), () {
      _initializeRoute();
    });
  }

  Future<void> _initializeRoute() async {
    if (!_isMapReady || _mapController == null) {
      print('DEBUG: Map not ready yet, retrying...');
      Future.delayed(const Duration(milliseconds: 500), () {
        _initializeRoute();
      });
      return;
    }

    print('DEBUG: Initializing route...');

    final originLatLng = LatLng(
      widget.origin['latitude'] as double,
      widget.origin['longitude'] as double,
    );
    final destinationLatLng = LatLng(
      widget.destination['latitude'] as double,
      widget.destination['longitude'] as double,
    );

  

    // Thêm markers trước
    await _addMarkers(originLatLng, destinationLatLng);

    // Sau đó tìm đường đi
    await _findRoute(originLatLng, destinationLatLng);
  }

  Future<void> _findRoute(LatLng origin, LatLng destination) async {
    if (_mapController == null) return;

    try {
      // Sử dụng VietMap plugin để tìm đường đi theo tài liệu
      var routingResponse = await Vietmap.routing(VietMapRoutingParams(points: [
        origin,
        destination,
      ]));

  

      // Handle the response
      routingResponse.fold(
        (Failure failure) {
          print('DEBUG: Routing failed: ${failure.toString()}');
          // handle failure here - sử dụng tính toán đơn giản
          _calculateSimpleRoute(origin, destination);
        },
        (VietMapRoutingModel success) {
        
          // handle success here
          _processRoutingData(success, origin, destination);
        },
      );

      setState(() {});

      // Fit map để hiển thị cả 2 điểm
      await _mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(
          LatLngBounds(
            southwest: LatLng(
              origin.latitude < destination.latitude
                  ? origin.latitude
                  : destination.latitude,
              origin.longitude < destination.longitude
                  ? origin.longitude
                  : destination.longitude,
            ),
            northeast: LatLng(
              origin.latitude > destination.latitude
                  ? origin.latitude
                  : destination.latitude,
              origin.longitude > destination.longitude
                  ? origin.longitude
                  : destination.longitude,
            ),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi khi tạo đường đi: $e'),
          backgroundColor: AppTheme.warningRed,
        ),
      );
    }
  }

  Future<void> _addMarkers(LatLng origin, LatLng destination) async {
    if (_mapController == null) return;

    try {
     
      // Thêm marker cho origin (màu xanh) - sử dụng cách đơn giản
      _originMarker = await _mapController!.addSymbol(
        SymbolOptions(
          geometry: origin,
          iconSize: 2.0,
          iconImage: "default_marker", // Sử dụng icon mặc định
          iconColor: const Color(0xFF007AFF), // Màu xanh
          textField: "Điểm đi",
          textSize: 12.0,
          textColor: const Color(0xFF007AFF),
        ),
      );

      // Thêm marker cho destination (màu đỏ)
      _destinationMarker = await _mapController!.addSymbol(
        SymbolOptions(
          geometry: destination,
          iconSize: 2.0,
          iconImage: "default_marker", // Sử dụng icon mặc định
          iconColor: const Color(0xFFFF3B30), // Màu đỏ
          textField: "Điểm đến",
          textSize: 12.0,
          textColor: const Color(0xFFFF3B30),
        ),
      );

    } catch (e) {
    
      // Fallback: thử cách khác
      try {
    
        _originMarker = await _mapController!.addSymbol(
          SymbolOptions(
            geometry: origin,
            iconSize: 1.5,
            iconImage: "marker-15",
            iconColor: const Color(0xFF007AFF),
          ),
        );
        _destinationMarker = await _mapController!.addSymbol(
          SymbolOptions(
            geometry: destination,
            iconSize: 1.5,
            iconImage: "marker-15",
            iconColor: const Color(0xFFFF3B30),
          ),
        );
        print('DEBUG: Fallback markers added successfully');
      } catch (e2) {
        print('DEBUG: Fallback markers also failed: $e2');
      }
    }
  }

  void _processRoutingData(
      VietMapRoutingModel routingData, LatLng origin, LatLng destination) {
    try {
      print('DEBUG: Processing routing data');
      // TODO: Implement proper routing data parsing when API structure is confirmed
      // For now, use simple calculation
      _calculateSimpleRoute(origin, destination);
    } catch (e) {
      print('DEBUG: Error processing routing data: $e');
      // Fallback to simple calculation
      _calculateSimpleRoute(origin, destination);
    }
  }

  Future<void> _drawRouteOnMap() async {
    if (_mapController == null || _routePoints.isEmpty) {
      return;
    }

    try {
      

      // Draw the route on the map theo tài liệu
      _routeLine = await _mapController!.addPolyline(
        PolylineOptions(
          geometry: _routePoints,
          polylineColor: AppTheme.accentBlue,
          polylineWidth: 6.0, // Tăng độ dày
          polylineOpacity: 1.0, // Tăng độ đậm
        ),
      );


    } catch (e) {

      // Fallback: thử cách khác
        _routeLine = await _mapController!.addPolyline(
          PolylineOptions(
            geometry: _routePoints,
            polylineColor: Colors.red, // Màu đỏ để dễ nhìn
            polylineWidth: 8.0,
            polylineOpacity: 1.0,
          ),
        );
      
    }
  }

  void _calculateSimpleRoute(LatLng origin, LatLng destination) {
   

    // Tính khoảng cách đơn giản nếu API thất bại
    _distance = _calculateDistance(origin, destination);
    _duration = (_distance * 2).round(); // Ước tính 2 phút/km

    // Tạo nhiều điểm trung gian để polyline mượt hơn
    _routePoints = _generateIntermediatePoints(origin, destination);

   

    // Vẽ đường thẳng đơn giản
    _drawRouteOnMap();
  }

  List<LatLng> _generateIntermediatePoints(LatLng start, LatLng end) {
    List<LatLng> points = [start];

    // Thêm 5 điểm trung gian
    for (int i = 1; i <= 5; i++) {
      double ratio = i / 6.0;
      double lat = start.latitude + (end.latitude - start.latitude) * ratio;
      double lng = start.longitude + (end.longitude - start.longitude) * ratio;
      points.add(LatLng(lat, lng));
    }

    points.add(end);
    return points;
  }

  double _calculateDistance(LatLng start, LatLng end) {
    const double earthRadius = 6371; // km
    final double lat1 = start.latitude * (pi / 180);
    final double lat2 = end.latitude * (pi / 180);
    final double deltaLat = (end.latitude - start.latitude) * (pi / 180);
    final double deltaLng = (end.longitude - start.longitude) * (pi / 180);

    final double a = sin(deltaLat / 2) * sin(deltaLat / 2) +
        cos(lat1) * cos(lat2) * sin(deltaLng / 2) * sin(deltaLng / 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Stack(
        children: [
          // Map View
          VietmapGL(
            styleString: VietMapConstants.mapStyleUrl,
            onMapCreated: _onMapCreated,
            initialCameraPosition: const CameraPosition(
              target: LatLng(10.759091, 106.675817),
              zoom: 12,
            ),
            onMapLongClick: (point, coordinates) {
              // Handle map long press if needed
            },
          ),

          // Header with origin/destination
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.cardBackground,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Origin
                  Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: AppTheme.accentBlue,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.origin['name'] ?? 'Điểm đi',
                              style: AppTheme.body1.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              widget.origin['address'] ?? '',
                              style: AppTheme.body2.copyWith(
                                color: AppTheme.lightGray,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Arrow
                  Container(
                    margin: const EdgeInsets.only(left: 5),
                    width: 2,
                    height: 20,
                    color: AppTheme.lightGray,
                  ),

                  const SizedBox(height: 12),

                  // Destination
                  Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: AppTheme.warningRed,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.destination['name'] ?? 'Điểm đến',
                              style: AppTheme.body1.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              widget.destination['address'] ?? '',
                              style: AppTheme.body2.copyWith(
                                color: AppTheme.lightGray,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Route Info Banner
          if (_distance > 0)
            Positioned(
              top: MediaQuery.of(context).padding.top + 140,
              left: 16,
              right: 16,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppTheme.cardBackground,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.route,
                      color: AppTheme.accentBlue,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${_distance.toStringAsFixed(1)} km • $_duration phút',
                      style: AppTheme.body2.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Bottom Ride Options Panel
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: AppTheme.cardBackground,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle bar
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppTheme.lightGray,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Service Options
                  ..._services.map((service) => _buildServiceOption(service)),

                  const SizedBox(height: 20),

                  // Payment and Booking Section
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        // Payment Method
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppTheme.lightGray),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                               children: [
                                Text(
                                  "Tiền mặt",
                                  style: AppTheme.body2,
                                ),
                                 Spacer(),
                                 Icon(Icons.keyboard_arrow_down, size: 20),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Book Button
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: _bookRide,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.accentBlue,
                              foregroundColor: AppTheme.primaryWhite,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              'Đặt ${_services.firstWhere((s) => s['id'] == _selectedService)['name']}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: MediaQuery.of(context).padding.bottom + 10),
                ],
              ),
            ),
          ),

          // Loading overlay
          if (!_isMapReady)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppTheme.accentBlue),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildServiceOption(Map<String, dynamic> service) {
    final isSelected = _selectedService == service['id'];

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedService = service['id'];
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.accentBlue.withOpacity(0.1)
              : AppTheme.cardBackground,
          border: Border.all(
            color: isSelected
                ? AppTheme.accentBlue
                : AppTheme.lightGray.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              service['icon'],
              color: service['color'],
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        service['name'],
                        style: AppTheme.body1.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (service['id'] == 'beShare')
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.accentBlue,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'BETA',
                            style: TextStyle(
                              color: AppTheme.primaryWhite,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                  Text(
                    service['subtitle'],
                    style: AppTheme.body2.copyWith(
                      color: AppTheme.lightGray,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              service['price'],
              style: AppTheme.body1.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.accentBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _bookRide() {
    // TODO: Implement booking functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Đặt ${_services.firstWhere((s) => s['id'] == _selectedService)['name']} thành công!'),
        backgroundColor: AppTheme.accentBlue,
      ),
    );
  }
}
