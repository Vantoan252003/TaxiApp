import 'package:flutter/material.dart';
import '../../../general_lib/constants/app_theme.dart';

class LocationCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final String? selectedAddress;
  final bool isLoading;
  final VoidCallback? onTap;
  final VoidCallback? onClear;
  final VoidCallback? onUseCurrentLocation;
  final bool showUseCurrentLocation;

  const LocationCard({
    super.key,
    required this.title,
    required this.icon,
    required this.iconColor,
    this.selectedAddress,
    this.isLoading = false,
    this.onTap,
    this.onClear,
    this.onUseCurrentLocation,
    this.showUseCurrentLocation = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryBlack.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: iconColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        icon,
                        color: iconColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        title,
                        style: AppTheme.heading3.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (showUseCurrentLocation && onUseCurrentLocation != null)
                      TextButton.icon(
                        onPressed: onUseCurrentLocation,
                        icon: const Icon(
                          Icons.my_location,
                          size: 16,
                          color: AppTheme.accentBlue,
                        ),
                        label: const Text(
                          'Vị trí hiện tại',
                          style: TextStyle(
                            color: AppTheme.accentBlue,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),

                // Content
                if (isLoading)
                  const Row(
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Đang lấy vị trí...',
                        style: AppTheme.body2,
                      ),
                    ],
                  )
                else if (selectedAddress != null && selectedAddress!.isNotEmpty)
                  _buildSelectedLocation()
                else
                  _buildPlaceholder(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedLocation() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Đã chọn',
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.lightGray,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                selectedAddress!,
                style: AppTheme.body1.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppTheme.darkGray,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        if (onClear != null)
          IconButton(
            onPressed: onClear,
            icon: const Icon(
              Icons.close,
              size: 20,
              color: AppTheme.lightGray,
            ),
            style: IconButton.styleFrom(
              backgroundColor: AppTheme.backgroundColor,
              padding: const EdgeInsets.all(8),
            ),
          ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Chọn $title',
                style: AppTheme.body2.copyWith(
                  color: AppTheme.lightGray,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Nhấn để tìm kiếm',
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.lightGray,
                ),
              ),
            ],
          ),
        ),
        Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: AppTheme.lightGray,
        ),
      ],
    );
  }
}
