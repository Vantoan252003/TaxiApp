import 'package:flutter/foundation.dart';

class PlaceModel {
  final String id;
  final String name;
  final String display;
  final String address;
  final double? latitude;
  final double? longitude;
  final List<String> categories;
  final Map<String, dynamic> boundaries;

  const PlaceModel({
    required this.id,
    required this.name,
    required this.display,
    required this.address,
    this.latitude,
    this.longitude,
    this.categories = const [],
    this.boundaries = const {},
  });

  factory PlaceModel.fromMap(Map<String, dynamic> map) {
    try {
      // Convert categories from List<dynamic> to List<String>
      List<String> categories = [];
      if (map['categories'] != null) {
        if (map['categories'] is List) {
          categories =
              (map['categories'] as List).map((e) => e.toString()).toList();
        }
      }

      // Convert boundaries from List<dynamic> to Map<String, dynamic>
      Map<String, dynamic> boundaries = {};
      if (map['boundaries'] != null) {
        if (map['boundaries'] is List) {
          boundaries = {'list': map['boundaries']};
        } else if (map['boundaries'] is Map) {
          boundaries = Map<String, dynamic>.from(map['boundaries']);
        }
      }

      return PlaceModel(
        id: map['ref_id']?.toString() ?? '',
        name: map['name']?.toString() ?? '',
        display: map['display']?.toString() ?? '',
        address: map['address']?.toString() ?? '',
        latitude: map['lat']?.toDouble(),
        longitude: map['lng']?.toDouble(),
        categories: categories,
        boundaries: boundaries,
      );
    } catch (e) {
      debugPrint('Error creating PlaceModel from map: $e');
      debugPrint('Map data: $map');
      rethrow;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'ref_id': id,
      'name': name,
      'display': display,
      'address': address,
      'lat': latitude,
      'lng': longitude,
      'categories': categories,
      'boundaries': boundaries,
    };
  }

  @override
  String toString() {
    return 'PlaceModel(id: $id, name: $name, display: $display, address: $address)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PlaceModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class ReverseGeocodingResponse {
  final bool success;
  final String message;
  final List<ReverseGeocodingData> data;
  final String timestamp;

  ReverseGeocodingResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.timestamp,
  });

  factory ReverseGeocodingResponse.fromJson(Map<String, dynamic> json) {
    return ReverseGeocodingResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
              ?.map((item) => ReverseGeocodingData.fromJson(item))
              .toList() ??
          [],
      timestamp: json['timestamp'] ?? '',
    );
  }
}

class ReverseGeocodingData {
  final double lat;
  final double lng;
  final double distance;
  final String address;
  final String name;
  final String display;
  final List<Boundary> boundaries;
  final List<dynamic> categories;
  final String refId;
  final List<dynamic> entryPoints;

  ReverseGeocodingData({
    required this.lat,
    required this.lng,
    required this.distance,
    required this.address,
    required this.name,
    required this.display,
    required this.boundaries,
    required this.categories,
    required this.refId,
    required this.entryPoints,
  });

  factory ReverseGeocodingData.fromJson(Map<String, dynamic> json) {
    return ReverseGeocodingData(
      lat: (json['lat'] as num?)?.toDouble() ?? 0.0,
      lng: (json['lng'] as num?)?.toDouble() ?? 0.0,
      distance: (json['distance'] as num?)?.toDouble() ?? 0.0,
      address: json['address'] ?? '',
      name: json['name'] ?? '',
      display: json['display'] ?? '',
      boundaries: (json['boundaries'] as List<dynamic>?)
              ?.map((item) => Boundary.fromJson(item))
              .toList() ??
          [],
      categories: json['categories'] ?? [],
      refId: json['ref_id'] ?? '',
      entryPoints: json['entry_points'] ?? [],
    );
  }
}

class Boundary {
  final int type;
  final int id;
  final String name;
  final String prefix;
  final String fullName;

  Boundary({
    required this.type,
    required this.id,
    required this.name,
    required this.prefix,
    required this.fullName,
  });

  factory Boundary.fromJson(Map<String, dynamic> json) {
    return Boundary(
      type: json['type'] ?? 0,
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      prefix: json['prefix'] ?? '',
      fullName: json['full_name'] ?? '',
    );
  }
}

class AutocompleteResponse {
  final bool success;
  final String message;
  final List<AutocompleteData> data;
  final String timestamp;

  AutocompleteResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.timestamp,
  });

  factory AutocompleteResponse.fromJson(Map<String, dynamic> json) {
    return AutocompleteResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
              ?.map((item) => AutocompleteData.fromJson(item))
              .toList() ??
          [],
      timestamp: json['timestamp'] ?? '',
    );
  }
}

class AutocompleteData {
  final double distance;
  final String address;
  final String name;
  final String display;
  final List<Boundary> boundaries;
  final List<String> categories;
  final String refId;
  final List<dynamic> entryPoints;

  AutocompleteData({
    required this.distance,
    required this.address,
    required this.name,
    required this.display,
    required this.boundaries,
    required this.categories,
    required this.refId,
    required this.entryPoints,
  });

  factory AutocompleteData.fromJson(Map<String, dynamic> json) {
    return AutocompleteData(
      distance: (json['distance'] as num?)?.toDouble() ?? 0.0,
      address: json['address'] ?? '',
      name: json['name'] ?? '',
      display: json['display'] ?? '',
      boundaries: (json['boundaries'] as List<dynamic>?)
              ?.map((item) => Boundary.fromJson(item))
              .toList() ??
          [],
      categories: (json['categories'] as List<dynamic>?)
              ?.map((item) => item.toString())
              .toList() ??
          [],
      refId: json['ref_id'] ?? '',
      entryPoints: json['entry_points'] ?? [],
    );
  }
}

// Place detail response models
class PlaceDetailResponse {
  final bool success;
  final String message;
  final List<PlaceDetailData> data;
  final String timestamp;

  PlaceDetailResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.timestamp,
  });

  factory PlaceDetailResponse.fromJson(Map<String, dynamic> json) {
    return PlaceDetailResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
              ?.map((item) => PlaceDetailData.fromJson(item))
              .toList() ??
          [],
      timestamp: json['timestamp'] ?? '',
    );
  }
}

class PlaceDetailData {
  final String display;
  final String name;
  final String street;
  final String address;
  final String city;
  final String district;
  final String ward;
  final double lat;
  final double lng;
  final String hsNum;
  final int cityId;
  final int districtId;
  final int wardId;

  PlaceDetailData({
    required this.display,
    required this.name,
    required this.street,
    required this.address,
    required this.city,
    required this.district,
    required this.ward,
    required this.lat,
    required this.lng,
    required this.hsNum,
    required this.cityId,
    required this.districtId,
    required this.wardId,
  });

  factory PlaceDetailData.fromJson(Map<String, dynamic> json) {
    return PlaceDetailData(
      display: json['display'] ?? '',
      name: json['name'] ?? '',
      street: json['street'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      district: json['district'] ?? '',
      ward: json['ward'] ?? '',
      lat: (json['lat'] as num?)?.toDouble() ?? 0.0,
      lng: (json['lng'] as num?)?.toDouble() ?? 0.0,
      hsNum: json['hs_num'] ?? '',
      cityId: json['city_id'] ?? 0,
      districtId: json['district_id'] ?? 0,
      wardId: json['ward_id'] ?? 0,
    );
  }
}
