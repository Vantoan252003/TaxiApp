import 'package:flutter/material.dart';
import '../../general_lib/constants/app_theme.dart';
import '../models/trip_model.dart';

class TripItem extends StatelessWidget {
  final TripModel trip;
  final VoidCallback? onTap;

  const TripItem({
    super.key,
    required this.trip,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: AppTheme.cardDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with date and status
            Row(
              children: [
                Expanded(
                  child: Text(
                    trip.formattedDate,
                    style: AppTheme.body1.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: trip.statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    trip.statusText,
                    style: AppTheme.caption.copyWith(
                      color: trip.statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Route info
            Row(
              children: [
                // Pickup dot
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppTheme.successGreen,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    trip.pickupLocation,
                    style: AppTheme.body2,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            // Route line
            Container(
              margin: const EdgeInsets.only(left: 3),
              width: 2,
              height: 8,
              color: AppTheme.borderColor,
            ),

            // Destination
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppTheme.warningRed,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    trip.destinationLocation,
                    style: AppTheme.body2,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Footer with driver and fare
            Row(
              children: [
                // Driver info
                Expanded(
                  child: Row(
                    children: [
                      // Driver avatar
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppTheme.backgroundColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppTheme.borderColor,
                            width: 1,
                          ),
                        ),
                        child: trip.driverAvatar.isNotEmpty
                            ? ClipOval(
                                child: Image.network(
                                  trip.driverAvatar,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return _buildDriverAvatar();
                                  },
                                ),
                              )
                            : _buildDriverAvatar(),
                      ),
                      const SizedBox(width: 8),
                      // Driver name
                      Expanded(
                        child: Text(
                          trip.driverName,
                          style: AppTheme.body2.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),

                // Rating (if available)
                if (trip.rating > 0) ...[
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 14,
                        color: AppTheme.warningOrange,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        trip.rating.toStringAsFixed(1),
                        style: AppTheme.caption.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                ],

                // Fare
                Text(
                  trip.formattedFare,
                  style: AppTheme.body1.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.accentBlue,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDriverAvatar() {
    return Center(
      child: Text(
        trip.driverInitials,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AppTheme.primaryBlack,
        ),
      ),
    );
  }
}
