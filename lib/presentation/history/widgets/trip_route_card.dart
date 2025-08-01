import 'package:flutter/material.dart';
import '../../../core/constants/app_theme.dart';
import '../../../data/models/trip_model.dart';

class TripRouteCard extends StatelessWidget {
  final TripModel trip;

  const TripRouteCard({
    super.key,
    required this.trip,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hành trình',
            style: AppTheme.heading3,
          ),
          const SizedBox(height: 20),

          // Pickup location
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: AppTheme.successGreen,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Điểm đón',
                      style: AppTheme.caption.copyWith(
                        color: AppTheme.mediumGray,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      trip.pickupLocation,
                      style: AppTheme.body1,
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Route line
          Container(
            margin: const EdgeInsets.only(left: 5),
            width: 2,
            height: 20,
            color: AppTheme.borderColor,
          ),

          // Destination location
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: AppTheme.warningRed,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Điểm đến',
                      style: AppTheme.caption.copyWith(
                        color: AppTheme.mediumGray,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      trip.destinationLocation,
                      style: AppTheme.body1,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Trip details
          Row(
            children: [
              Expanded(
                child: _buildDetailItem(
                  icon: Icons.straighten,
                  label: 'Khoảng cách',
                  value: trip.formattedDistance,
                ),
              ),
              if (trip.tripDuration != null) ...[
                Expanded(
                  child: _buildDetailItem(
                    icon: Icons.access_time,
                    label: 'Thời gian',
                    value: '${trip.tripDuration} phút',
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          size: 20,
          color: AppTheme.mediumGray,
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: AppTheme.caption.copyWith(
            color: AppTheme.mediumGray,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTheme.body1.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
