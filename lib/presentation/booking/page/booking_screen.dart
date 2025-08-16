import 'package:flutter/material.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';
import '../widgets/floating_address_widget.dart';
import '../widgets/ride_options_panel.dart';
import '../widgets/map_section_widget.dart';
import '../widgets/driver_info_overlay.dart';
import '../../../data/models/fare_estimate_model.dart';
import '../../../data/models/driver_model.dart';

class RideScreen extends StatefulWidget {
  final String origin;
  final String destination;
  final VietmapController? mapController;
  final LatLng? originLatLng;
  final LatLng? destinationLatLng;
  final FareEstimateResponse? fareEstimate;
  final List<DriverModel>? nearbyDrivers;

  const RideScreen({
    super.key,
    required this.origin,
    required this.destination,
    this.mapController,
    this.originLatLng,
    this.destinationLatLng,
    this.fareEstimate,
    this.nearbyDrivers,
  });

  @override
  State<RideScreen> createState() => _RideScreenState();
}

class _RideScreenState extends State<RideScreen> {
  String _selectedVehicleType = 'Car';

  // Tọa độ mẫu cho điểm đi và điểm đến (sử dụng tọa độ từ VietMap API example)
  late final LatLng _originLatLng;
  late final LatLng _destinationLatLng;

  @override
  void initState() {
    super.initState();
    // Use provided coordinates or fallback to coordinates from VietMap API example
    _originLatLng = widget.originLatLng ??
        const LatLng(10.79628438955497, 106.70592293472612);
    _destinationLatLng = widget.destinationLatLng ??
        const LatLng(10.801891047584164, 106.70660958023404);

    // Set default selected vehicle type from fare estimate
    if (widget.fareEstimate != null &&
        widget.fareEstimate!.data.fares.isNotEmpty) {
      final firstFare = widget.fareEstimate!.data.fares.first;
      _selectedVehicleType = _mapVehicleTypeToId(firstFare.vehicleType);
    } else {
      // If no fare estimate, set to empty string to prevent selection
      _selectedVehicleType = '';
    }

    // Debug: Print driver information
    print('🚗 RideScreen initialized:');
    print('   Origin: ${widget.origin}');
    print('   Destination: ${widget.destination}');
    print(
        '   Origin LatLng: ${_originLatLng.latitude}, ${_originLatLng.longitude}');
    print(
        '   Destination LatLng: ${_destinationLatLng.latitude}, ${_destinationLatLng.longitude}');
    print('   Nearby drivers: ${widget.nearbyDrivers?.length ?? 0}');
    if (widget.nearbyDrivers != null && widget.nearbyDrivers!.isNotEmpty) {
      for (int i = 0; i < widget.nearbyDrivers!.length; i++) {
        final driver = widget.nearbyDrivers![i];
        print(
            '   Driver $i: ${driver.userId} at ${driver.latitude}, ${driver.longitude}');
      }
    }
  }

  String _mapVehicleTypeToId(String vehicleType) {
    switch (vehicleType) {
      case 'MOTORCYCLE':
        return 'Motorcycle';
      case 'CAR':
        return 'Car';
      case 'BICYCLE':
        return 'Bike';
      case 'TRUCK':
        return 'Truck';
      default:
        return 'Car';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Full screen map
          MapSectionWidget(
            originLatLng: _originLatLng,
            destinationLatLng: _destinationLatLng,
            nearbyDrivers: widget.nearbyDrivers,
          ),

          // Floating address window
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 0,
            right: 0,
            child: FloatingAddressWidget(
              origin: widget.origin,
              destination: widget.destination,
              onBack: () => Navigator.pop(context),
              onSwap: _swapAddresses,
              onAddStop: _addStop,
            ),
          ),

          // Driver info overlay
          if (widget.nearbyDrivers != null)
            DriverInfoOverlay(
              drivers: widget.nearbyDrivers!,
              isLoading: false, // Không loading vì đã có data
            ),

          // Bottom ride options panel
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: RideOptionsPanel(
              selectedVehicleType: _selectedVehicleType,
              onVehicleSelected: _selectVehicle,
              onBookNow: _bookNow,
              onBookSelected: _bookSelectedVehicle,
              fareEstimate: widget.fareEstimate,
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods
  void _swapAddresses() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Swap addresses')),
    );
  }

  void _addStop() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Add stop')),
    );
  }

  void _selectVehicle(String vehicleId) {
    if (vehicleId.isNotEmpty) {
      setState(() {
        _selectedVehicleType = vehicleId;
      });
    }
  }

  void _bookNow() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Booking now...')),
    );
  }

  void _bookSelectedVehicle() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Booking $_selectedVehicleType...')),
    );
  }
}
