import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class RecentDestination {
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final DateTime timestamp;

  RecentDestination({
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory RecentDestination.fromJson(Map<String, dynamic> json) {
    return RecentDestination(
      name: json['name'],
      address: json['address'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}

class RecentDestinationsService {
  static const String _cacheKey = 'recent_destinations';
  static const int _maxDestinations = 10;

  // Lưu điểm đi mới vào cache
  static Future<void> addRecentDestination(
      RecentDestination destination) async {
    final prefs = await SharedPreferences.getInstance();
    final destinations = await getRecentDestinations();

    final existingIndex = destinations.indexWhere(
        (d) => d.name == destination.name && d.address == destination.address);

    if (existingIndex != -1) {
      // Cập nhật timestamp nếu đã tồn tại
      destinations[existingIndex] = destination;
    } else {
      // Thêm mới vào đầu danh sách
      destinations.insert(0, destination);
    }

    // Giới hạn số lượng điểm lưu trữ
    if (destinations.length > _maxDestinations) {
      destinations.removeRange(_maxDestinations, destinations.length);
    }

    // Lưu vào SharedPreferences
    final jsonList = destinations.map((d) => d.toJson()).toList();
    await prefs.setString(_cacheKey, jsonEncode(jsonList));
  }

  // Lấy danh sách điểm đi gần đây
  static Future<List<RecentDestination>> getRecentDestinations() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_cacheKey);

      if (jsonString == null || jsonString.isEmpty) {
        return [];
      }

      final jsonList = jsonDecode(jsonString) as List;
      final destinations =
          jsonList.map((json) => RecentDestination.fromJson(json)).toList();

      // Sắp xếp theo thời gian gần nhất
      destinations.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      return destinations;
    } catch (e) {
      return [];
    }
  }

  // Xóa một điểm đi khỏi cache
  static Future<void> removeRecentDestination(
      RecentDestination destination) async {
    final prefs = await SharedPreferences.getInstance();
    final destinations = await getRecentDestinations();

    destinations.removeWhere(
        (d) => d.name == destination.name && d.address == destination.address);

    final jsonList = destinations.map((d) => d.toJson()).toList();
    await prefs.setString(_cacheKey, jsonEncode(jsonList));
  }

  // Xóa tất cả điểm đi gần đây
  static Future<void> clearAllRecentDestinations() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cacheKey);
  }

  // Kiểm tra xem có điểm đi gần đây nào không
  static Future<bool> hasRecentDestinations() async {
    final destinations = await getRecentDestinations();
    return destinations.isNotEmpty;
  }
}
