import 'package:flutter/material.dart';
import 'package:taxi_app/core/constants/app_theme.dart';
import 'autocomplete_field.dart';
import '../../../data/models/place_model.dart';

class LocationInputSection extends StatelessWidget {
  final TextEditingController originController;
  final TextEditingController destinationController;
  final bool isDestinationFocused;
  final bool isLoadingOrigin;
  final VoidCallback? onDestinationTap;
  final VoidCallback? onSwapLocations;
  final VoidCallback? onAddDestination;
  final Function(AutocompleteData)? onOriginPlaceSelected;
  final Function(AutocompleteData)? onDestinationPlaceSelected;
  final Function(bool)? onOriginFocusChanged;
  final Function(bool)? onDestinationFocusChanged;
  final VoidCallback? onGetCurrentLocation;

  const LocationInputSection({
    super.key,
    required this.originController,
    required this.destinationController,
    required this.isDestinationFocused,
    this.isLoadingOrigin = false,
    this.onDestinationTap,
    this.onSwapLocations,
    this.onAddDestination,
    this.onOriginPlaceSelected,
    this.onDestinationPlaceSelected,
    this.onOriginFocusChanged,
    this.onDestinationFocusChanged,
    this.onGetCurrentLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            // Column 1: Input fields
            Expanded(
              child: Column(
                children: [
                  // Origin input - separate container
                  AutocompleteField(
                    controller: originController,
                    icon: Icons.person_pin,
                    iconColor: const Color.fromARGB(255, 200, 218, 234),
                    hintText: "Điểm đi",
                    isActive: true,
                    isLoading: isLoadingOrigin,
                    onPlaceSelected: onOriginPlaceSelected ?? (place) {},
                    onFocusChanged: onOriginFocusChanged ?? (focused) {},
                    onGetLocation: onGetCurrentLocation,
                  ),
                  const SizedBox(height: 8),
                  // Destination input - separate container
                  AutocompleteField(
                    controller: destinationController,
                    icon: Icons.location_on,
                    iconColor: Colors.orange,
                    hintText: "Nhập điểm đến",
                    isActive: true,
                    onPlaceSelected: onDestinationPlaceSelected ?? (place) {},
                    onFocusChanged: onDestinationFocusChanged ?? (focused) {},
                  ),
                ],
              ),
            ),
            // Column 2: Swap button (centered vertically)
            SizedBox(
              width: 35,
              height: 120, // Adjust height to match both input fields + spacing
              child: Center(
                child: InkWell(
                  onTap: onSwapLocations,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 216, 214, 214),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.swap_vert,
                      size: 20,
                      color: AppTheme.primaryBlack,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Add destination button - separate container
        InkWell(
          onTap: () {},
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              children: [
                Icon(Icons.add, color: Colors.grey.shade600, size: 20),
                const SizedBox(width: 8),
                Text(
                  "Nhấn để thêm điểm đến",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
