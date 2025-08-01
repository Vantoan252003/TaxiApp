import 'package:flutter/material.dart';

class TripModel {
  final String id;
  final String driverName;
  final String driverPhone;
  final String driverAvatar;
  final String vehicleNumber;
  final String vehicleModel;
  final String vehicleColor;
  final String pickupLocation;
  final String destinationLocation;
  final DateTime tripDate;
  final double distance; // in km
  final double fare; // in VND
  final String status; // 'completed', 'cancelled', 'ongoing'
  final double rating;
  final String? review;
  final String? paymentMethod;
  final String? tripDuration; // in minutes

  TripModel({
    required this.id,
    required this.driverName,
    required this.driverPhone,
    required this.driverAvatar,
    required this.vehicleNumber,
    required this.vehicleModel,
    required this.vehicleColor,
    required this.pickupLocation,
    required this.destinationLocation,
    required this.tripDate,
    required this.distance,
    required this.fare,
    required this.status,
    required this.rating,
    this.review,
    this.paymentMethod,
    this.tripDuration,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'driverName': driverName,
      'driverPhone': driverPhone,
      'driverAvatar': driverAvatar,
      'vehicleNumber': vehicleNumber,
      'vehicleModel': vehicleModel,
      'vehicleColor': vehicleColor,
      'pickupLocation': pickupLocation,
      'destinationLocation': destinationLocation,
      'tripDate': tripDate.toIso8601String(),
      'distance': distance,
      'fare': fare,
      'status': status,
      'rating': rating,
      'review': review,
      'paymentMethod': paymentMethod,
      'tripDuration': tripDuration,
    };
  }

  // Create from JSON
  factory TripModel.fromJson(Map<String, dynamic> json) {
    return TripModel(
      id: json['id'] ?? '',
      driverName: json['driverName'] ?? '',
      driverPhone: json['driverPhone'] ?? '',
      driverAvatar: json['driverAvatar'] ?? '',
      vehicleNumber: json['vehicleNumber'] ?? '',
      vehicleModel: json['vehicleModel'] ?? '',
      vehicleColor: json['vehicleColor'] ?? '',
      pickupLocation: json['pickupLocation'] ?? '',
      destinationLocation: json['destinationLocation'] ?? '',
      tripDate: DateTime.parse(json['tripDate']),
      distance: (json['distance'] ?? 0).toDouble(),
      fare: (json['fare'] ?? 0).toDouble(),
      status: json['status'] ?? 'completed',
      rating: (json['rating'] ?? 0).toDouble(),
      review: json['review'],
      paymentMethod: json['paymentMethod'],
      tripDuration: json['tripDuration'],
    );
  }

  // Get formatted date
  String get formattedDate {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tripDay = DateTime(tripDate.year, tripDate.month, tripDate.day);

    if (tripDay == today) {
      return 'Hôm nay';
    } else if (tripDay == today.subtract(const Duration(days: 1))) {
      return 'Hôm qua';
    } else {
      return '${tripDate.day.toString().padLeft(2, '0')}/${tripDate.month.toString().padLeft(2, '0')}/${tripDate.year}';
    }
  }

  // Get formatted time
  String get formattedTime {
    return '${tripDate.hour.toString().padLeft(2, '0')}:${tripDate.minute.toString().padLeft(2, '0')}';
  }

  // Get formatted fare
  String get formattedFare {
    return '${fare.toStringAsFixed(0)} VNĐ';
  }

  // Get formatted distance
  String get formattedDistance {
    return '${distance.toStringAsFixed(1)} km';
  }

  // Get status color
  Color get statusColor {
    switch (status) {
      case 'completed':
        return const Color(0xFF34C759); // Green
      case 'cancelled':
        return const Color(0xFFFF3B30); // Red
      case 'ongoing':
        return const Color(0xFFFF9500); // Orange
      default:
        return const Color(0xFF666666); // Gray
    }
  }

  // Get status text
  String get statusText {
    switch (status) {
      case 'completed':
        return 'Hoàn thành';
      case 'cancelled':
        return 'Đã hủy';
      case 'ongoing':
        return 'Đang di chuyển';
      default:
        return 'Không xác định';
    }
  }

  // Get driver initials
  String get driverInitials {
    if (driverName.isEmpty) return 'D';
    final names = driverName.trim().split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[names.length - 1][0]}'.toUpperCase();
    }
    return driverName[0].toUpperCase();
  }
}
