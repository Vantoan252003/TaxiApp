import 'package:flutter/material.dart';
import 'package:taxi_app/presentation/promo/screen/promo_screen.dart';
import '../../../data/models/fare_estimate_model.dart';

class RideOptionsPanel extends StatefulWidget {
  final String selectedVehicleType;
  final Function(String) onVehicleSelected;
  final VoidCallback onBookNow;
  final VoidCallback onBookSelected;
  final FareEstimateResponse? fareEstimate;

  const RideOptionsPanel({
    super.key,
    required this.selectedVehicleType,
    required this.onVehicleSelected,
    required this.onBookNow,
    required this.onBookSelected,
    this.fareEstimate,
  });

  @override
  State<RideOptionsPanel> createState() => _RideOptionsPanelState();
}

class _RideOptionsPanelState extends State<RideOptionsPanel> {
  String _selectedPaymentMethod = 'Zalopay';
  String _selectedSchedule = 'Now';
  bool _hasPromo = true;

  List<Map<String, dynamic>> get _vehicleTypes {
    // Return empty list if no fare estimate available
    if (widget.fareEstimate == null ||
        widget.fareEstimate!.data.fares.isEmpty) {
      return [];
    }

    // Map API data to vehicle types
    final vehicleTypeMap = {
      'MOTORCYCLE': {
        'id': 'Motorcycle',
        'name': 'Xe máy',
        'icon': Icons.motorcycle,
        'description': 'Great price',
        'passengers': 1,
        'color': Colors.orange,
      },
      'CAR': {
        'id': 'Car',
        'name': 'Car',
        'icon': Icons.directions_car,
        'description': '4-seater car with extra legroom',
        'passengers': 4,
        'color': Colors.amber,
      },
      'BICYCLE': {
        'id': 'Bike',
        'name': 'Xe đạp',
        'icon': Icons.people,
        'description': 'Share ride with 1 other',
        'passengers': 1,
        'color': Colors.blue,
        'isBeta': true,
      },
      'TRUCK': {
        'id': 'Truck',
        'name': 'Xe tải',
        'icon': Icons.local_shipping,
        'description': 'Large capacity vehicle',
        'passengers': 2,
        'color': Colors.grey,
      },
    };

    return widget.fareEstimate!.data.fares.map((fare) {
      final baseInfo = vehicleTypeMap[fare.vehicleType] ??
          {
            'id': fare.vehicleType,
            'name': fare.vehicleType,
            'icon': Icons.directions_car,
            'description': 'Standard vehicle',
            'passengers': 4,
            'color': Colors.grey,
          };

      final originalPrice =
          fare.estimatedFare + widget.fareEstimate!.data.promoDiscount;
      final finalPrice = fare.estimatedFare;

      return {
        ...baseInfo,
        'price': finalPrice,
        'originalPrice': originalPrice,
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // Thu nhỏ container bằng cách thêm margin

      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Trip info section
          if (widget.fareEstimate != null) _buildTripInfo(),

          // Ride options - scrollable với chiều cao cố định
          if (_vehicleTypes.isNotEmpty)
            Container(
              height: 200, // Chiều cao cố định để hiển thị ~3 items
              child: _buildRideOptions(),
            )
          else
            Container(
              height: 100,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline,
                        color: Colors.grey[400], size: 32),
                    const SizedBox(height: 8),
                    Text(
                      'Không có dữ liệu giá cước',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Control widgets
          _buildControlWidgets(),

          // Booking buttons
          if (_vehicleTypes.isNotEmpty) _buildBookingButtons(),

          // Bottom padding for safe area
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildTripInfo() {
    final data = widget.fareEstimate!.data;
    final distanceKm = (data.distance / 1000).toStringAsFixed(1);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.route, color: Colors.blue[600], size: 20),
              const SizedBox(width: 8),
              Text(
                '$distanceKm km',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 14),
              Icon(Icons.access_time, color: Colors.orange[600], size: 20),
              const SizedBox(width: 8),
              Text(
                '${data.estimatedDurationMinutes} phút',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (data.surgeMultiplier > 1.0) ...[
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${data.surgeMultiplier.toStringAsFixed(1)}x',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.red[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
          if (data.promoDiscount > 0.0) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.local_offer, color: Colors.green[600], size: 16),
                const SizedBox(width: 6),
                Text(
                  'Giảm ${data.promoDiscount.toStringAsFixed(0)}₫',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (data.promoCode != null) ...[
                  const SizedBox(width: 8),
                  Text(
                    '(${data.promoCode})',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRideOptions() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _vehicleTypes.length,
      itemBuilder: (context, index) {
        final vehicle = _vehicleTypes[index];
        final isSelected = widget.selectedVehicleType == vehicle['id'];

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
          decoration: BoxDecoration(
            color: isSelected ? Colors.amber.shade50 : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? Colors.amber : Colors.grey.shade200,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: InkWell(
            onTap: () => widget.onVehicleSelected(vehicle['id']),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  // Left side - Vehicle info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              vehicle['icon'],
                              color: vehicle['color'],
                              size: 20,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              vehicle['name'],
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(Icons.person, size: 14),
                            Text(
                              '${vehicle['passengers']}',
                              style: const TextStyle(fontSize: 12),
                            ),
                            if (vehicle['isBeta'] == true) ...[
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 1),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: const Text(
                                  'BETA',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          vehicle['description'],
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Right side - Price
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${vehicle['price'].toStringAsFixed(0)}₫',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (vehicle['originalPrice'] > vehicle['price'])
                        Text(
                          '${vehicle['originalPrice'].toStringAsFixed(0)}₫',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildControlWidgets() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Payment method - mở rộng hơn
          Expanded(
            flex: 3, // Tăng flex để rộng hơn
            child: _buildControlWidget(
              icon: Icons.payment,
              title: '$_selectedPaymentMethod*',
              onTap: _showPaymentOptions,
            ),
          ),
          const SizedBox(width: 12),
          // Promo - mở rộng hơn
          Expanded(
            flex: 3, // Tăng flex để rộng hơn
            child: _buildControlWidget(
              icon: Icons.local_offer,
              title: _hasPromo ? '1 Promo' : 'Add promo',
              hasIndicator: _hasPromo,
              onTap: _showPromoOptions,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlWidget({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool hasIndicator = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 12, vertical: 10), // Tăng padding
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16), // Tăng size icon
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 12, // Tăng font size
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (hasIndicator)
              Container(
                width: 6,
                height: 6,
                margin: const EdgeInsets.only(right: 4),
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
            const Icon(Icons.keyboard_arrow_down, size: 14),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingButtons() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Book selected vehicle button
          Expanded(
            child: ElevatedButton(
              onPressed: widget.onBookSelected,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 2,
              ),
              child: Text(
                'Book ${widget.selectedVehicleType}',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPaymentOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => _buildPaymentOptionsSheet(),
    );
  }

  void _showScheduleOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => _buildScheduleOptionsSheet(),
    );
  }

  void _showPromoOptions() {
    showDialog(
      context: context,
      builder: (context) => const PromoScreeen(),
    );
  }

  Widget _buildPaymentOptionsSheet() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Payment Method',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('Zalopay'),
            onTap: () {
              setState(() => _selectedPaymentMethod = 'Zalopay');
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.credit_card),
            title: const Text('Credit Card'),
            onTap: () {
              setState(() => _selectedPaymentMethod = 'Credit Card');
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleOptionsSheet() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Schedule Ride',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.schedule),
            title: const Text('Now'),
            onTap: () {
              setState(() => _selectedSchedule = 'Now');
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.access_time),
            title: const Text('Later'),
            onTap: () {
              setState(() => _selectedSchedule = 'Later');
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
