import 'package:flutter/material.dart';
import '../../general_lib/constants/app_theme.dart';
import '../models/trip_model.dart';
import '../widgets/trip_status_card.dart';
import '../widgets/trip_driver_card.dart';
import '../widgets/trip_route_card.dart';
import '../widgets/trip_payment_card.dart';

class TripDetailScreen extends StatelessWidget {
  final TripModel trip;

  const TripDetailScreen({
    super.key,
    required this.trip,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Chi tiết chuyến đi'),
        backgroundColor: AppTheme.primaryWhite,
        foregroundColor: AppTheme.primaryBlack,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Trip Status Card
            TripStatusCard(trip: trip),

            const SizedBox(height: 16),

            // Driver Info Card
            TripDriverCard(trip: trip),

            const SizedBox(height: 16),

            // Trip Route Card
            TripRouteCard(trip: trip),

            const SizedBox(height: 16),

            // Trip Payment Card
            TripPaymentCard(trip: trip),

            // Review section (if completed and has review)
            if (trip.status == 'completed' && trip.review != null) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: AppTheme.cardDecoration,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Đánh giá của bạn',
                          style: AppTheme.heading3,
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              size: 16,
                              color: AppTheme.warningOrange,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              trip.rating.toStringAsFixed(1),
                              style: AppTheme.body2.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      trip.review!,
                      style: AppTheme.body2,
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
