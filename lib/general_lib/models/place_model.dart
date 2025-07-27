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
