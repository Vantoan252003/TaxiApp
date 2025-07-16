import 'package:flutter/material.dart';
import '../../general_lib/constants/app_theme.dart';
import 'home_location_input.dart';

class HomeLocationSection extends StatelessWidget {
  final String currentLocation;
  final bool isLoadingLocation;
  final String destinationHint;
  final VoidCallback onCurrentLocationTap;
  final VoidCallback onDestinationTap;

  const HomeLocationSection({
    super.key,
    required this.currentLocation,
    required this.isLoadingLocation,
    required this.destinationHint,
    required this.onCurrentLocationTap,
    required this.onDestinationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      transform: Matrix4.translationValues(0, -20, 0),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.borderColor,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryBlack.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Current Location
          HomeLocationInput(
            icon: Icons.my_location,
            text: currentLocation,
            isLoading: isLoadingLocation,
            onTap: onCurrentLocationTap,
          ),

          // Divider
          Container(
            height: 1,
            margin: const EdgeInsets.only(left: 50),
            color: AppTheme.borderColor,
          ),

          // Destination
          HomeLocationInput(
            icon: Icons.location_on_outlined,
            text: destinationHint,
            onTap: onDestinationTap,
          ),
        ],
      ),
    );
  }
}
