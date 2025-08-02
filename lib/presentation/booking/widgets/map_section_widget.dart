import 'package:flutter/material.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';

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
  Widget build(BuildContext context) {
    return VietmapGL(
      styleString:
          'https://maps.vietmap.vn/api/maps/light/styles.json?apikey=8e17c07d6fd7dacdb1e2e442ba74b4edbf874b863f3ac04d',
      initialCameraPosition: CameraPosition(
        target: widget.originLatLng,
        zoom: 14.0,
      ),
      onMapCreated: (VietmapController controller) {
        _mapController = controller;
        _addMarkersAndRoute();
      },
    );
  }

  void _addMarkersAndRoute() async {
    if (_mapController == null) return;

    // Thêm marker cho điểm đi (Symbols)
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

    // Thêm marker cho điểm đến (Symbols)
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

    // Thêm circle markers cho điểm đi
    await _mapController!.addCircle(
      CircleOptions(
        geometry: widget.originLatLng,
        circleRadius: 8.0,
        circleColor: Colors.blue, // Màu xanh dương
        circleStrokeColor: Colors.white, // Màu trắng
        circleStrokeWidth: 2.0,
      ),
    );

    // Thêm circle markers cho điểm đến
    await _mapController!.addCircle(
      CircleOptions(
        geometry: widget.destinationLatLng,
        circleRadius: 8.0,
        circleColor: Colors.red, // Màu cam
        circleStrokeColor: Colors.white, // Màu trắng
        circleStrokeWidth: 2.0,
      ),
    );

    // Fit camera để hiển thị cả 2 điểm
    _fitCameraToBounds();
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
