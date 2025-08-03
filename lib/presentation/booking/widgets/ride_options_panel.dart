import 'package:flutter/material.dart';

class RideOptionsPanel extends StatefulWidget {
  final String selectedVehicleType;
  final Function(String) onVehicleSelected;
  final VoidCallback onBookNow;
  final VoidCallback onBookSelected;

  const RideOptionsPanel({
    super.key,
    required this.selectedVehicleType,
    required this.onVehicleSelected,
    required this.onBookNow,
    required this.onBookSelected,
  });

  @override
  State<RideOptionsPanel> createState() => _RideOptionsPanelState();
}

class _RideOptionsPanelState extends State<RideOptionsPanel> {
  String _selectedPaymentMethod = 'Zalopay';
  String _selectedSchedule = 'Now';
  bool _hasPromo = true;

  final List<Map<String, dynamic>> _vehicleTypes = [
    {
      'id': 'Car',
      'name': 'Car',
      'icon': Icons.directions_car,
      'description': '4-seater car with extra legroom',
      'price': 127000.0,
      'originalPrice': 149000.0,
      'passengers': 4,
      'color': Colors.amber,
    },
    {
      'id': 'Bike',
      'name': 'Xe đạp',
      'icon': Icons.people,
      'description': 'Share ride with 1 other',
      'price': 98000.0,
      'originalPrice': 121000.0,
      'passengers': 1,
      'color': Colors.blue,
      'isBeta': true,
    },
    {
      'id': 'Motorcycle',
      'name': 'Xe máy',
      'icon': Icons.motorcycle,
      'description': 'Great price',
      'price': 51000.0,
      'originalPrice': 51000.0,
      'passengers': 1,
      'color': Colors.orange,
    },
    {
      'id': 'Ô tô 4 chỗ',
      'name': 'beCar 4',
      'icon': Icons.directions_car,
      'description': 'Standard 4-seater',
      'price': 114000.0,
      'originalPrice': 114000.0,
      'passengers': 4,
      'color': Colors.grey,
    },
    {
      'id': 'Premium',
      'name': 'Premium Car',
      'icon': Icons.directions_car,
      'description': 'Luxury ride experience',
      'price': 180000.0,
      'originalPrice': 180000.0,
      'passengers': 4,
      'color': Colors.purple,
    },
  ];

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

          // Ride options - scrollable với chiều cao cố định
          Container(
            height: 200, // Chiều cao cố định để hiển thị ~3 items
            child: _buildRideOptions(),
          ),

          // Control widgets
          _buildControlWidgets(),

          // Booking buttons
          _buildBookingButtons(),

          // Bottom padding for safe area
          const SizedBox(height: 8),
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
    showModalBottomSheet(
      context: context,
      builder: (context) => _buildPromoOptionsSheet(),
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

  Widget _buildPromoOptionsSheet() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Promo Codes',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          if (_hasPromo)
            ListTile(
              leading: const Icon(Icons.local_offer, color: Colors.green),
              title: const Text('WELCOME10'),
              subtitle: const Text('10% off your first ride'),
              onTap: () => Navigator.pop(context),
            ),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Add Promo Code'),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
