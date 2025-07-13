import 'package:flutter/material.dart';
import '../../general_lib/constants/app_theme.dart';
import '../../general_lib/services/location_service.dart';

class MainHomeScreen extends StatefulWidget {
  // Public static constants for widget access
  static const String defaultLocationText = 'Đang lấy vị trí...';
  static const String destinationHint = 'Nhập vào để đặt xe máy, xe hơi ...';

  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  String _currentLocation = 'Đang lấy vị trí...';
  bool _isLoadingLocation = true;

  // Cache static data
  static const String _defaultLocationText = 'Đang lấy vị trí...';
  static const String _destinationHint = 'Nhập vào để đặt xe máy, xe hơi ...';
  static const String _errorLocationText = 'Lỗi khi lấy vị trí';
  static const String _noLocationText = 'Không thể lấy vị trí hiện tại';

  @override
  void initState() {
    super.initState();
    _currentLocation = _defaultLocationText;
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      final String? address = await LocationService.getCurrentAddress();
      if (mounted) {
        setState(() {
          _currentLocation = address ?? _noLocationText;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _currentLocation = _errorLocationText;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingLocation = false;
        });
      }
    }
  }

  void _showDestinationPicker() {
    // TODO: Implement destination picker
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Chức năng chọn điểm đến đang phát triển'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Banner Section
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.accentBlue,
                    Color(
                        0xFF005BB5), // Optimized: Direct color instead of withOpacity
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Top banner with illustration
                    _BannerWidget(
                      onLocationTap: _getCurrentLocation,
                      onDestinationTap: _showDestinationPicker,
                      currentLocationText: _currentLocation,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Location Input Section - Moved outside banner for better performance
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              transform: Matrix4.translationValues(0, -20, 0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1A000000), // Optimized: Direct color
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Current Location
                  _buildLocationInput(
                    icon: Icons.radio_button_checked,
                    iconColor: AppTheme.accentBlue,
                    text: _isLoadingLocation
                        ? _defaultLocationText
                        : _currentLocation,
                    isLoading: _isLoadingLocation,
                    onTap: _getCurrentLocation,
                  ),

                  // Divider
                  Container(
                    height: 1,
                    margin: const EdgeInsets.only(left: 50),
                    color: AppTheme.borderColor,
                  ),

                  // Destination
                  _buildLocationInput(
                    icon: Icons.location_on,
                    iconColor: AppTheme.warningRed,
                    text: _destinationHint,
                    onTap: _showDestinationPicker,
                  ),
                ],
              ),
            ),

            // Services Grid
            Expanded(
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Services Grid
                      Expanded(
                        child: _ServicesGrid(onServiceTap: _handleServiceTap),
                      ),

                      // Promotion Section
                      const _PromotionSection(),

                      // Suggestion Section
                      const _SuggestionSection(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationInput({
    required IconData icon,
    required Color iconColor,
    required String text,
    required VoidCallback onTap,
    bool isLoading = false,
  }) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: isLoading
                  ? Row(
                      children: [
                        const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          text,
                          style: AppTheme.body1.copyWith(
                            color: AppTheme.mediumGray,
                          ),
                        ),
                      ],
                    )
                  : Text(
                      text,
                      style: AppTheme.body1.copyWith(
                        color: text.startsWith('Nhập')
                            ? AppTheme.mediumGray
                            : AppTheme.primaryBlack,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleServiceTap(String serviceType) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Dịch vụ $serviceType đang phát triển'),
      ),
    );
  }
}

// Separate widget classes for better performance
class _BannerWidget extends StatelessWidget {
  final VoidCallback onLocationTap;
  final VoidCallback onDestinationTap;
  final String currentLocationText;

  const _BannerWidget({
    required this.onLocationTap,
    required this.onDestinationTap,
    required this.currentLocationText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1E88E5),
            Color(0xFF1565C0),
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person,
                          color: Color(0xFF1565C0),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tài khoản của bạn',
                            style: AppTheme.body2.copyWith(
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                          Text(
                            'Hãy trải nghiệm ngay',
                            style: AppTheme.body1.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.notifications_outlined,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Location Inputs
              _LocationInputWidget(
                onLocationTap: onLocationTap,
                onDestinationTap: onDestinationTap,
                currentLocationText: currentLocationText,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LocationInputWidget extends StatelessWidget {
  final VoidCallback onLocationTap;
  final VoidCallback onDestinationTap;
  final String currentLocationText;

  const _LocationInputWidget({
    required this.onLocationTap,
    required this.onDestinationTap,
    required this.currentLocationText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // From Location
          _LocationInputItem(
            onTap: onLocationTap,
            text: currentLocationText,
            dotColor: const Color(0xFF4CAF50),
            isCurrentLocation: true,
            isPlaceholder:
                currentLocationText == MainHomeScreen.defaultLocationText,
          ),

          const SizedBox(height: 12),

          // To Location
          _LocationInputItem(
            onTap: onDestinationTap,
            text: MainHomeScreen.destinationHint,
            dotColor: AppTheme.warningRed,
            isCurrentLocation: false,
            isPlaceholder: true,
          ),
        ],
      ),
    );
  }
}

class _LocationInputItem extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final Color dotColor;
  final bool isCurrentLocation;
  final bool isPlaceholder;

  const _LocationInputItem({
    required this.onTap,
    required this.text,
    required this.dotColor,
    required this.isCurrentLocation,
    required this.isPlaceholder,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: AppTheme.lightGray.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: AppTheme.body1.copyWith(
                  color: isPlaceholder
                      ? AppTheme.mediumGray
                      : AppTheme.primaryBlack,
                ),
              ),
            ),
            if (isCurrentLocation)
              const Icon(
                Icons.my_location,
                color: Color(0xFF1565C0),
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}

class _ServicesGrid extends StatelessWidget {
  final Function(String) onServiceTap;

  const _ServicesGrid({required this.onServiceTap});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 4,
      crossAxisSpacing: 15,
      mainAxisSpacing: 20,
      children: const [
        _ServiceItem(
          icon: Icons.motorcycle,
          title: 'Đặt xe máy',
          color: AppTheme.warningRed,
          serviceType: 'motorcycle',
        ),
        _ServiceItem(
          icon: Icons.directions_car,
          title: 'Xe hơi riêng',
          color: AppTheme.accentBlue,
          serviceType: 'private_car',
        ),
        _ServiceItem(
          icon: Icons.directions_car,
          title: 'Xe taxi',
          color: AppTheme.accentBlue,
          serviceType: 'taxi',
        ),
        _ServiceItem(
          icon: Icons.electric_car,
          title: 'Xe điện',
          color: AppTheme.successGreen,
          serviceType: 'electric',
        ),
      ],
    );
  }
}

class _ServiceItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final String serviceType;

  const _ServiceItem({
    required this.icon,
    required this.title,
    required this.color,
    required this.serviceType,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Dịch vụ $title đang phát triển'),
          ),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color, color.withOpacity(0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: AppTheme.body2.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _PromotionSection extends StatelessWidget {
  const _PromotionSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.lightGray.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.card_giftcard,
            color: AppTheme.successGreen,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Mời 20 bạn bè tải app để nhận ví lên đến 1.000.000đ',
              style: AppTheme.body2.copyWith(
                color: AppTheme.primaryBlack,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: AppTheme.successGreen,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'NHẬP MÃ MỚI NAY NHÉ',
              style: AppTheme.body2.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SuggestionSection extends StatelessWidget {
  const _SuggestionSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gợi ý cho bạn',
            style: AppTheme.heading3.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.successGreen,
                  AppTheme.successGreen.withOpacity(0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'ĐẶT TRƯỚC CHUYẾN ĐI XA',
                          style: AppTheme.heading3.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'GIÁ SIÊU RẺ',
                          style: AppTheme.heading2.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Taxi Hà Tình',
                          style: AppTheme.body1.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Taxi tại Hà Tình giá rẻ',
                          style: AppTheme.body2.copyWith(
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Illustration space
                  const SizedBox(width: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
