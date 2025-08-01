import 'package:flutter/material.dart';
import '../../../core/constants/app_theme.dart';
import '../../../data/models/trip_model.dart';

class TripDriverCard extends StatelessWidget {
  final TripModel trip;

  const TripDriverCard({
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
          const Text(
            'Thông tin tài xế',
            style: AppTheme.heading3,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              // Driver avatar
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppTheme.backgroundColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.borderColor,
                    width: 2,
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
              const SizedBox(width: 16),
              // Driver details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      trip.driverName,
                      style: AppTheme.heading3,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      trip.vehicleModel,
                      style: AppTheme.body1,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${trip.vehicleColor} • ${trip.vehicleNumber}',
                      style: AppTheme.body2.copyWith(
                        color: AppTheme.mediumGray,
                      ),
                    ),
                    if (trip.rating > 0) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            size: 16,
                            color: AppTheme.warningOrange,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${trip.rating.toStringAsFixed(1)} (${trip.rating.toInt()})',
                            style: AppTheme.body2.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              // Call button
              IconButton(
                onPressed: () => _callDriver(context),
                icon: Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: AppTheme.successGreen,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.phone,
                    color: AppTheme.primaryWhite,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDriverAvatar() {
    return Center(
      child: Text(
        trip.driverInitials,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppTheme.primaryBlack,
        ),
      ),
    );
  }

  void _callDriver(BuildContext context) {
    // TODO: Implement phone call functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Gọi cho ${trip.driverName}: ${trip.driverPhone}'),
        backgroundColor: AppTheme.successGreen,
      ),
    );
  }
}
