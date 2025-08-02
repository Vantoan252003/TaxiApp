import 'package:flutter/material.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';
import 'package:vietmap_flutter_plugin/vietmap_flutter_plugin.dart';

class MapSectionWidget extends StatefulWidget {
  final LatLng originLatLng;
  final LatLng destinationLatLng;

  const MapSectionWidget({
    super.key,
    required this.originLatLng,
    required this.destinationLatLng,
  });

  @override
  State<MapSectionWidget> createState() => _MapSectionWidgetState();
}

class _MapSectionWidgetState extends State<MapSectionWidget> {
  VietmapController? _mapController;
  Line? _routeLine; // Biến để lưu đường polyline

  @override
  void initState() {
    super.initState();
    // Initialize Vietmap plugin
    Vietmap.getInstance('8e17c07d6fd7dacdb1e2e442ba74b4edbf874b863f3ac04d');

    // Debug: Check coordinates
    print('DEBUG: MapSectionWidget initialized');
    print(
        'DEBUG: Origin coordinates: ${widget.originLatLng.latitude}, ${widget.originLatLng.longitude}');
    print(
        'DEBUG: Destination coordinates: ${widget.destinationLatLng.latitude}, ${widget.destinationLatLng.longitude}');
  }

  @override
  Widget build(BuildContext context) {
    print('DEBUG: Building MapSectionWidget');
    return VietmapGL(
      styleString:
          'https://maps.vietmap.vn/api/maps/light/styles.json?apikey=8e17c07d6fd7dacdb1e2e442ba74b4edbf874b863f3ac04d',
      initialCameraPosition: CameraPosition(
        target: widget.originLatLng,
        zoom: 14.0,
      ),
      onMapCreated: (VietmapController controller) {
        print('DEBUG: Map created');
        _mapController = controller;
        _addMarkersAndRoute();
      },
    );
  }

  void _addMarkersAndRoute() async {
    print('DEBUG: Adding markers and route');
    if (_mapController == null) {
      print('DEBUG: Map controller is null');
      return;
    }

    try {
      // Thêm marker cho điểm đi (Symbols)
      print(
          'DEBUG: Adding origin marker at: ${widget.originLatLng.latitude}, ${widget.originLatLng.longitude}');
      await _mapController!.addSymbol(
        SymbolOptions(
          geometry: widget.originLatLng,
          iconImage: "marker-15",
          iconSize: 2.0,
          textField: "Điểm đi",
          textOffset: const Offset(0, 2),
          textColor: Colors.blue, // Màu xanh dương
        ),
      );
      print('DEBUG: Origin marker added successfully');

      // Thêm marker cho điểm đến (Symbols)
      print(
          'DEBUG: Adding destination marker at: ${widget.destinationLatLng.latitude}, ${widget.destinationLatLng.longitude}');
      await _mapController!.addSymbol(
        SymbolOptions(
          geometry: widget.destinationLatLng,
          iconImage: "marker-15",
          iconSize: 2.0,
          textField: "Điểm đến",
          textOffset: const Offset(0, 2),
          textColor: Colors.orange, // Màu cam
        ),
      );
      print('DEBUG: Destination marker added successfully');

      // Thêm circle markers cho điểm đi
      print('DEBUG: Adding origin circle marker');
      await _mapController!.addCircle(
        CircleOptions(
          geometry: widget.originLatLng,
          circleRadius: 8.0,
          circleColor: Colors.blue, // Màu xanh dương
          circleStrokeColor: Colors.white, // Màu trắng
          circleStrokeWidth: 2.0,
        ),
      );
      print('DEBUG: Origin circle marker added successfully');

      // Thêm circle markers cho điểm đến
      print('DEBUG: Adding destination circle marker');
      await _mapController!.addCircle(
        CircleOptions(
          geometry: widget.destinationLatLng,
          circleRadius: 8.0,
          circleColor: Colors.red, // Màu cam
          circleStrokeColor: Colors.white, // Màu trắng
          circleStrokeWidth: 2.0,
        ),
      );
      print('DEBUG: Destination circle marker added successfully');

      print('DEBUG: All markers added, now getting route');
      // Lấy đường đi và vẽ polyline
      await _getAndDrawRoute();

      // Fit camera để hiển thị cả 2 điểm
      print('DEBUG: Fitting camera to bounds');
      _fitCameraToBounds();
    } catch (e) {
      print('DEBUG: Error adding markers: $e');
      print('DEBUG: Error type: ${e.runtimeType}');
    }
  }

  Future<void> _getAndDrawRoute() async {
    print('DEBUG: Starting to get route');
    print(
        'DEBUG: Origin: ${widget.originLatLng.latitude}, ${widget.originLatLng.longitude}');
    print(
        'DEBUG: Destination: ${widget.destinationLatLng.latitude}, ${widget.destinationLatLng.longitude}');

    try {
      // Gọi API routing để lấy đường đi
      print('DEBUG: Calling Vietmap.routing API...');
      final routingResult = await Vietmap.routing(
        VietMapRoutingParams(
          points: [
            widget.originLatLng,
            widget.destinationLatLng,
          ],
        ),
      );

      print('DEBUG: Routing API called, processing result...');
      // Xử lý kết quả routing
      routingResult.fold(
        (Failure failure) {
          print('DEBUG: Routing failed: ${failure.toString()}');
          // Fallback: vẽ đường thẳng giữa 2 điểm
          _drawStraightLine();
        },
        (routes) {
          print('DEBUG: Routing successful, routes: $routes');
          // Vẽ đường đi nếu có kết quả
          if (routes != null) {
            _drawRouteFromResponse(routes);
          } else {
            print('DEBUG: Routes is null, drawing straight line');
            _drawStraightLine();
          }
        },
      );
    } catch (e) {
      print('DEBUG: Error getting route: $e');
      print('DEBUG: Error type: ${e.runtimeType}');
      // Fallback: vẽ đường thẳng giữa 2 điểm
      _drawStraightLine();
    }
  }

  void _drawRouteFromResponse(dynamic routes) async {
    if (_mapController == null) return;

    try {
      print('DEBUG: Drawing route from response: $routes');
      print('DEBUG: Routes type: ${routes.runtimeType}');

      // Xóa polyline cũ nếu có
      if (_routeLine != null) {
        await _mapController!.removePolyline(_routeLine!);
      }

      // Tạo danh sách các điểm từ route geometry
      List<LatLng> routePoints = [];

      // Parse route geometry từ response
      if (routes is Map && routes['geometry'] != null) {
        print('DEBUG: Found geometry in routes: ${routes['geometry']}');
        print('DEBUG: Geometry type: ${routes['geometry'].runtimeType}');

        // Nếu geometry là encoded polyline, decode nó
        if (routes['geometry'] is String) {
          print('DEBUG: Geometry is string, decoding polyline...');
          routePoints = _decodePolyline(routes['geometry'] as String);
          print('DEBUG: Decoded ${routePoints.length} points from polyline');
        } else if (routes['geometry'] is List) {
          print('DEBUG: Geometry is list, processing coordinates...');
          // Nếu geometry là array of coordinates
          final coords = routes['geometry'] as List;
          for (var coord in coords) {
            if (coord is List && coord.length >= 2) {
              routePoints.add(LatLng(coord[1].toDouble(), coord[0].toDouble()));
            }
          }
          print(
              'DEBUG: Processed ${routePoints.length} points from coordinates list');
        }
      } else if (routes is List && routes.isNotEmpty) {
        print('DEBUG: Routes is a list, processing first route...');
        final route = routes.first;
        print('DEBUG: First route: $route');
        print('DEBUG: First route type: ${route.runtimeType}');

        if (route is Map && route['geometry'] != null) {
          print('DEBUG: Found geometry in first route: ${route['geometry']}');
          if (route['geometry'] is String) {
            routePoints = _decodePolyline(route['geometry'] as String);
            print(
                'DEBUG: Decoded ${routePoints.length} points from first route polyline');
          } else if (route['geometry'] is List) {
            final coords = route['geometry'] as List;
            for (var coord in coords) {
              if (coord is List && coord.length >= 2) {
                routePoints
                    .add(LatLng(coord[1].toDouble(), coord[0].toDouble()));
              }
            }
            print(
                'DEBUG: Processed ${routePoints.length} points from first route coordinates');
          }
        }
      } else {
        print('DEBUG: No valid geometry found in routes');
      }

      // Nếu vẫn không có điểm, vẽ đường thẳng
      if (routePoints.isEmpty) {
        print('DEBUG: No route points found, drawing straight line');
        _drawStraightLine();
        return;
      }

      print('DEBUG: Drawing polyline with ${routePoints.length} points');
      // Vẽ polyline
      _routeLine = await _mapController!.addPolyline(
        PolylineOptions(
          geometry: routePoints,
          polylineColor: Colors.blue,
          polylineWidth: 4.0,
        ),
      );

      print(
          'DEBUG: Route drawn successfully with ${routePoints.length} points');
    } catch (e) {
      print('DEBUG: Error drawing route: $e');
      print('DEBUG: Error type: ${e.runtimeType}');
      _drawStraightLine();
    }
  }

  void _drawStraightLine() async {
    if (_mapController == null) return;

    try {
      // Xóa polyline cũ nếu có
      if (_routeLine != null) {
        await _mapController!.removePolyline(_routeLine!);
      }

      // Vẽ đường thẳng giữa 2 điểm
      _routeLine = await _mapController!.addPolyline(
        PolylineOptions(
          geometry: [widget.originLatLng, widget.destinationLatLng],
          polylineColor: Colors.blue,
          polylineWidth: 4.0,
        ),
      );

      print('Straight line drawn between points');
    } catch (e) {
      print('Error drawing straight line: $e');
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> poly = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      final p = LatLng((lat / 1E5).toDouble(), (lng / 1E5).toDouble());
      poly.add(p);
    }
    return poly;
  }

  void _fitCameraToBounds() {
    if (_mapController == null) return;

    double minLat =
        widget.originLatLng.latitude < widget.destinationLatLng.latitude
            ? widget.originLatLng.latitude
            : widget.destinationLatLng.latitude;
    double maxLat =
        widget.originLatLng.latitude > widget.destinationLatLng.latitude
            ? widget.originLatLng.latitude
            : widget.destinationLatLng.latitude;
    double minLng =
        widget.originLatLng.longitude < widget.destinationLatLng.longitude
            ? widget.originLatLng.longitude
            : widget.destinationLatLng.longitude;
    double maxLng =
        widget.originLatLng.longitude > widget.destinationLatLng.longitude
            ? widget.originLatLng.longitude
            : widget.destinationLatLng.longitude;

    // Tính toán điểm trung tâm
    double centerLat = (minLat + maxLat) / 2;
    double centerLng = (minLng + maxLng) / 2;

    // Tính toán zoom level dựa trên khoảng cách
    double latDiff = maxLat - minLat;
    double lngDiff = maxLng - minLng;
    double maxDiff = latDiff > lngDiff ? latDiff : lngDiff;

    // Cải thiện công thức tính zoom để hiển thị tốt hơn
    double zoom = 15.0 - (maxDiff * 50); // Điều chỉnh hệ số từ 100 xuống 50
    if (zoom < 8.0) zoom = 8.0; // Zoom tối thiểu
    if (zoom > 16.0) zoom = 16.0; // Zoom tối đa

    // Animate camera để hiển thị đẹp hơn
    _mapController!.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(centerLat, centerLng),
        zoom,
      ),
    );
  }

  @override
  void dispose() {
    // Dọn dẹp resources khi widget bị dispose
    if (_routeLine != null && _mapController != null) {
      _mapController!.removePolyline(_routeLine!);
    }
    super.dispose();
  }
}
