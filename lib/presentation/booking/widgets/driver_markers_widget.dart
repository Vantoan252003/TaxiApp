import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';
import '../../../data/models/driver_model.dart';

class DriverMarkersWidget extends StatefulWidget {
  final VietmapController? mapController;
  final List<DriverModel> drivers;
  final bool isLoading;

  const DriverMarkersWidget({
    super.key,
    this.mapController,
    required this.drivers,
    required this.isLoading,
  });

  @override
  State<DriverMarkersWidget> createState() => _DriverMarkersWidgetState();
}

class _DriverMarkersWidgetState extends State<DriverMarkersWidget> {
  Uint8List? _motorcycleImage;

  @override
  void initState() {
    super.initState();
    _loadMotorcycleImage();
  }

  Future<void> _loadMotorcycleImage() async {
    try {
      final ByteData bytes =
          await rootBundle.load('assets/images/booking/motorcycle.png');
      _motorcycleImage = bytes.buffer.asUint8List();
      setState(() {});
    } catch (e) {
      // Fallback to default icon if image loading fails
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.mapController == null || widget.drivers.isEmpty) {
      return const SizedBox.shrink();
    }

    final markers = widget.drivers.map((driver) {
      return Marker(
        child: Image.memory(
          _motorcycleImage!,
          width: 40,
          height: 40,
          fit: BoxFit.contain,
        ),
        latLng: LatLng(driver.latitude, driver.longitude),
      );
    }).toList();

    return MarkerLayer(
      ignorePointer: true,
      mapController: widget.mapController!,
      markers: markers,
    );
  }
}
