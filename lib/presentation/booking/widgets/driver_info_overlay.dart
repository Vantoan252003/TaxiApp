import 'package:flutter/material.dart';
import '../../../data/models/driver_model.dart';

class DriverInfoOverlay extends StatelessWidget {
  final List<DriverModel> drivers;
  final bool isLoading;

  const DriverInfoOverlay({
    super.key,
    required this.drivers,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 80,
      right: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isLoading)
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              )
            else
              Icon(
                Icons.motorcycle,
                size: 16,
                color: drivers.isNotEmpty ? Colors.green : Colors.grey,
              ),
            const SizedBox(width: 8),
            Text(
              isLoading
                  ? 'Đang tìm...'
                  : drivers.isNotEmpty
                      ? '${drivers.length} tài xế gần đây'
                      : 'Không có tài xế',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: drivers.isNotEmpty ? Colors.green : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
