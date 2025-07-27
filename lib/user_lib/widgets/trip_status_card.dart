import 'package:flutter/material.dart';
import '../../general_lib/constants/app_theme.dart';
import '../models/trip_model.dart';

class TripStatusCard extends StatelessWidget {
  final TripModel trip;

  const TripStatusCard({
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
        children: [
          // Status icon and text
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: trip.statusColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getStatusIcon(),
              size: 32,
              color: trip.statusColor,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            trip.statusText,
            style: AppTheme.heading2.copyWith(
              color: trip.statusColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${trip.formattedDate} • ${trip.formattedTime}',
            style: AppTheme.body2.copyWith(
              color: AppTheme.mediumGray,
            ),
          ),
          const SizedBox(height: 12),
          // Trip ID
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.backgroundColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.borderColor),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
               const Icon(
                  Icons.qr_code,
                  size: 16,
                  color: AppTheme.mediumGray,
                ),
                const SizedBox(width: 6),
                Text(
                  'Mã chuyến đi: ${trip.id}',
                  style: AppTheme.caption.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.darkGray,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getStatusIcon() {
    switch (trip.status) {
      case 'completed':
        return Icons.check_circle;
      case 'cancelled':
        return Icons.cancel;
      case 'ongoing':
        return Icons.directions_car;
      default:
        return Icons.info;
    }
  }
}
