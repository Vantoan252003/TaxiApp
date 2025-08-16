class DriverModel {
  final String userId;
  final double latitude;
  final double longitude;

  DriverModel({
    required this.userId,
    required this.latitude,
    required this.longitude,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  // Create from JSON
  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel(
      userId: json['userId'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
    );
  }

  // Copy with method for updates
  DriverModel copyWith({
    String? userId,
    double? latitude,
    double? longitude,
  }) {
    return DriverModel(
      userId: userId ?? this.userId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  @override
  String toString() {
    return 'DriverModel(userId: $userId, latitude: $latitude, longitude: $longitude)';
  }
}
