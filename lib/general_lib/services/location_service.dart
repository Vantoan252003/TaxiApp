import 'package:geolocator/geolocator.dart';
import 'vietmap_service.dart';

class LocationService {
  static Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  static Future<Position?> getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return null;

    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      return null;
    }
  }

  static Future<String> getAddressFromPosition(Position position) async {
    try {
      final vietmapAddress = await VietMapService.getAddressFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (vietmapAddress != null && vietmapAddress.isNotEmpty) {
        return vietmapAddress;
      }

      return 'Không thể xác định địa chỉ';
    } catch (e) {
      return 'Lỗi khi lấy địa chỉ';
    }
  }

  static Future<String?> getCurrentAddress() async {
    try {
      final vietmapAddress = await VietMapService.getCurrentAddress();
      if (vietmapAddress != null && vietmapAddress.isNotEmpty) {

        return vietmapAddress;
      }


      // Fallback về phương thức cũ nếu VietMap không hoạt động
      final position = await getCurrentPosition();
      if (position != null) {
        return await getAddressFromPosition(position);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
