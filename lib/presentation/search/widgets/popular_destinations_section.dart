import 'package:flutter/material.dart';

class PopularDestinationsSection extends StatelessWidget {
  final Function(String destination) onDestinationSelected;
  final VoidCallback? onGetCurrentLocation;
  final bool showCurrentLocation;

  const PopularDestinationsSection({
    super.key,
    required this.onDestinationSelected,
    this.onGetCurrentLocation,
    this.showCurrentLocation = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Điểm đến phổ biến",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        ..._getPopularDestinations().map(
          (destination) =>
              _buildDestinationItem(destination, onDestinationSelected),
        ),
        if (showCurrentLocation && onGetCurrentLocation != null) ...[
          const SizedBox(height: 8),
          _buildCurrentLocationItem(onGetCurrentLocation!),
        ],
      ],
    );
  }

  Widget _buildDestinationItem(
    Map<String, String> destination,
    Function(String) onDestinationSelected,
  ) {
    return InkWell(
      onTap: () => onDestinationSelected(destination['name']!),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Icon(Icons.location_on, color: Colors.grey.shade600, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    destination['name']!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "${destination['distance']} • ${destination['address']}",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(Icons.bookmark_border, color: Colors.grey.shade400, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentLocationItem(VoidCallback onGetCurrentLocation) {
    return InkWell(
      onTap: onGetCurrentLocation,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.blue.shade200),
        ),
        child: Row(
          children: [
            Icon(Icons.my_location, color: Colors.blue.shade600, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Vị trí hiện tại",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Nhấn để lấy vị trí hiện tại",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios,
                color: Colors.blue.shade400, size: 16),
          ],
        ),
      ),
    );
  }

  List<Map<String, String>> _getPopularDestinations() {
    return [
      {
        'name': 'Vinhomes Central Park',
        'distance': '6.3km',
        'address': '208 Nguyễn Hữu Cảnh, P.22, Q.Bình Thạnh, Hồ Chí Minh',
      },
      {
        'name': 'Saigon Centre',
        'distance': '7.2km',
        'address': '65 Lê Lợi, P.Bến Nghé, Q.1, Hồ Chí Minh',
      },
      {
        'name': 'Bến Xe Miền Đông Mới',
        'distance': '15.0km',
        'address': 'Xa Lộ Hà Nội, P.Long Bình, TP.Thủ Đức, Hồ Chí Minh',
      },
    ];
  }
}
