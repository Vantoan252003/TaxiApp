import 'package:flutter/material.dart';
import '../../../core/constants/app_theme.dart';
import 'home_location_input.dart';
import '../../search/screen/destination_selection_screen.dart';

class HomeLocationSection extends StatelessWidget {
  const HomeLocationSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      transform: Matrix4.translationValues(0, -10, 0),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(10),
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
            icon: Icons.search,
            text: "Bạn muốn đi đâu ?",
            isLoading: false,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DestinationSelectionScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
