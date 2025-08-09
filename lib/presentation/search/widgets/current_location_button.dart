import 'package:flutter/material.dart';

class CurrentLocationButton extends StatelessWidget {
  final bool isGettingCurrentLocation;
  final VoidCallback onTap;

  const CurrentLocationButton({
    super.key,
    required this.isGettingCurrentLocation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isGettingCurrentLocation ? null : onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Icon(Icons.my_location, color: Colors.blue[600], size: 20),
            const SizedBox(width: 12),
            if (isGettingCurrentLocation) ...[
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              const SizedBox(width: 12),
              Text(
                'Đang lấy vị trí hiện tại...',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ] else ...[
              const Text(
                'Sử dụng vị trí hiện tại',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
