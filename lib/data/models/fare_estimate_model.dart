class FareEstimateResponse {
  final bool success;
  final String message;
  final FareEstimateData data;
  final String timestamp;

  FareEstimateResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.timestamp,
  });

  factory FareEstimateResponse.fromJson(Map<String, dynamic> json) {
    return FareEstimateResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: FareEstimateData.fromJson(json['data'] ?? {}),
      timestamp: json['timestamp'] ?? '',
    );
  }
}

class FareEstimateData {
  final double distance;
  final int estimatedDurationMinutes;
  final double surgeMultiplier;
  final double promoDiscount;
  final String? promoCode;
  final List<FareOption> fares;

  FareEstimateData({
    required this.distance,
    required this.estimatedDurationMinutes,
    required this.surgeMultiplier,
    required this.promoDiscount,
    this.promoCode,
    required this.fares,
  });

  factory FareEstimateData.fromJson(Map<String, dynamic> json) {
    return FareEstimateData(
      distance: (json['distance'] ?? 0.0).toDouble(),
      estimatedDurationMinutes: json['estimatedDurationMinutes'] ?? 0,
      surgeMultiplier: (json['surgeMultiplier'] ?? 1.0).toDouble(),
      promoDiscount: (json['promoDiscount'] ?? 0.0).toDouble(),
      promoCode: json['promoCode'],
      fares: (json['fares'] as List<dynamic>?)
              ?.map((fare) => FareOption.fromJson(fare))
              .toList() ??
          [],
    );
  }
}

class FareOption {
  final String vehicleType;
  final double estimatedFare;

  FareOption({
    required this.vehicleType,
    required this.estimatedFare,
  });

  factory FareOption.fromJson(Map<String, dynamic> json) {
    return FareOption(
      vehicleType: json['vehicleType'] ?? '',
      estimatedFare: (json['estimatedFare'] ?? 0.0).toDouble(),
    );
  }
}
