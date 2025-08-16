import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';
import 'package:vietmap_flutter_plugin/vietmap_flutter_plugin.dart';
import '../../../data/models/driver_model.dart';
import 'driver_markers_widget.dart';

class MapSectionWidget extends StatefulWidget {
  final LatLng originLatLng;
  final LatLng destinationLatLng;
  final List<DriverModel>? nearbyDrivers;
  final bool isLoadingDrivers;

  const MapSectionWidget({
    super.key,
    required this.originLatLng,
    required this.destinationLatLng,
    this.nearbyDrivers,
    this.isLoadingDrivers = false,
  });

  @override
  State<MapSectionWidget> createState() => _MapSectionWidgetState();
}

class _MapSectionWidgetState extends State<MapSectionWidget> {
  VietmapController? _mapController;
  Line? _routeLine;
  List<LatLng> _routePoints = [];
  Timer? _polylineTimer;
  int _polylineIndex = 0;

  @override
  void initState() {
    super.initState();
    Vietmap.getInstance(
      '8e17c07d6fd7dacdb1e2e442ba74b4edbf874b863f3ac04d',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        VietmapGL(
          trackCameraPosition: true,
          styleString:
              'https://maps.vietmap.vn/api/maps/light/styles.json?apikey=8e17c07d6fd7dacdb1e2e442ba74b4edbf874b863f3ac04d',
          initialCameraPosition: CameraPosition(
            target: widget.originLatLng,
            zoom: 14.0,
          ),
          onMapCreated: (controller) async {
            _mapController = controller;
            setState(() {});
          },
          onStyleLoadedCallback: () async {
            await _addMarkersAndRoute();
          },
        ),
        if (widget.nearbyDrivers != null && _mapController != null)
          DriverMarkersWidget(
            mapController: _mapController,
            drivers: widget.nearbyDrivers!,
            isLoading: widget.isLoadingDrivers,
          ),
      ],
    );
  }

  Future<Uint8List> _loadAssetImage(String path) async {
    final ByteData bytes = await rootBundle.load(path);
    return bytes.buffer.asUint8List();
  }

  Future<void> _addMarkersAndRoute() async {
    if (_mapController == null) return;

    await _mapController!.addImage(
        'originIcon', await _loadAssetImage('assets/images/origin.png'));
    await _mapController!.addImage('destinationIcon',
        await _loadAssetImage('assets/images/destination.png'));

    await _mapController!.addSymbol(SymbolOptions(
      geometry: widget.originLatLng,
      iconImage: 'originIcon',
      iconSize: 0.8,
      iconAnchor: "bottom",
    ));
    await _mapController!.addSymbol(SymbolOptions(
      geometry: widget.destinationLatLng,
      iconImage: 'destinationIcon',
      iconSize: 0.8,
      iconAnchor: "bottom",
    ));

    final routingResult = await Vietmap.routing(
      VietMapRoutingParams(
        points: [widget.originLatLng, widget.destinationLatLng],
        vehicle: VehicleType.bike,
      ),
    );

    routingResult.fold(
      (failure) async {
        _routePoints = [widget.originLatLng, widget.destinationLatLng];
        _fitCameraToPolyline(_routePoints);
        _animatePolyline();
      },
      (routingModel) async {
        _routePoints = _extractRoutePointsFromModel(routingModel);
        if (_routePoints.isEmpty) {
          _routePoints = [widget.originLatLng, widget.destinationLatLng];
        }

        // Ensure the last point is the exact destination
        if (_routePoints.isNotEmpty) {
          final lastPoint = _routePoints.last;
          final destination = widget.destinationLatLng;
          final distance = _calculateDistance(lastPoint, destination);
          if (distance > 0.00009) {
            // ~10 meters in degrees
            _routePoints[_routePoints.length - 1] = destination;
          }
        }

        _fitCameraToPolyline(_routePoints);
        _animatePolyline();
      },
    );
  }

  double _calculateDistance(LatLng point1, LatLng point2) {
    return sqrt(pow(point1.latitude - point2.latitude, 2) +
        pow(point1.longitude - point2.longitude, 2));
  }

  void _animatePolyline() {
    _polylineIndex = 1;
    _routeLine = null;
    _polylineTimer?.cancel();

    _polylineTimer =
        Timer.periodic(const Duration(milliseconds: 30), (timer) async {
      if (_polylineIndex >= _routePoints.length) {
        await _drawPolyline(_routePoints);
        timer.cancel();
        return;
      }

      final subList = _routePoints.sublist(0, _polylineIndex);
      await _drawPolyline(subList);

      _polylineIndex += 2;
      if (_polylineIndex >= _routePoints.length - 5) {
        _polylineIndex = _routePoints.length;
      }
    });
  }

  Future<void> _drawPolyline(List<LatLng> points) async {
    if (_mapController == null) return;

    if (_routeLine == null) {
      _routeLine = await _mapController!.addPolyline(
        PolylineOptions(
          geometry: points,
          polylineColor: Colors.blueAccent,
          polylineOpacity: 0.9,
          polylineWidth: 6.0,
          polylineBlur: 0.5,
          polylineJoin: "round",
        ),
      );
    } else {
      await _mapController!.updatePolyline(
        _routeLine!,
        PolylineOptions(
          geometry: points,
        ),
      );
    }
  }

  void _fitCameraToPolyline(List<LatLng> points) {
    if (_mapController == null || points.isEmpty) return;

    if (points.length == 1) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(points.first, 15),
      );
      return;
    }

    double minLat = points.map((p) => p.latitude).reduce(min);
    double maxLat = points.map((p) => p.latitude).reduce(max);
    double minLng = points.map((p) => p.longitude).reduce(min);
    double maxLng = points.map((p) => p.longitude).reduce(max);

    final bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    _mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(bounds,
          left: 50, top: 50, right: 50, bottom: 450),
    );
  }

  List<LatLng> _extractRoutePointsFromModel(dynamic model) {
    final List<LatLng> pts = [];
    final data = model.toJson();

    if (data['paths'] != null &&
        data['paths'] is List &&
        data['paths'].isNotEmpty) {
      final firstPath = data['paths'][0];
      if (firstPath['points_encoded'] == true &&
          firstPath['points'] is String) {
        pts.addAll(_decodePolyline(firstPath['points']));
      } else if (firstPath['points'] is List) {
        for (var coord in firstPath['points']) {
          if (coord is List && coord.length >= 2) {
            pts.add(LatLng(coord[1].toDouble(), coord[0].toDouble()));
          }
        }
      }
    }
    return pts;
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

      poly.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return poly;
  }

  @override
  void dispose() {
    _polylineTimer?.cancel();
    if (_routeLine != null && _mapController != null) {
      _mapController!.removePolyline(_routeLine!);
    }
    super.dispose();
  }
}
