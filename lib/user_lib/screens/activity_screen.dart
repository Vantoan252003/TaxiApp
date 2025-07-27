import 'package:flutter/material.dart';
import '../../general_lib/constants/app_theme.dart';
import '../models/trip_model.dart';
import '../widgets/trip_item.dart';
import 'trip_detail_screen.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  // Mock data for trips
  List<TripModel> _getMockTrips() {
    return [
      TripModel(
        id: '1',
        driverName: 'Nguyễn Văn An',
        driverPhone: '0123456789',
        driverAvatar: '',
        vehicleNumber: '30A-12345',
        vehicleModel: 'Toyota Vios',
        vehicleColor: 'Trắng',
        pickupLocation: 'Vincom Center, 72 Lê Thánh Tôn, Quận 1, TP.HCM',
        destinationLocation:
            'Landmark 81, Vinhomes Central Park, Quận Bình Thạnh, TP.HCM',
        tripDate: DateTime.now().subtract(const Duration(hours: 2)),
        distance: 8.5,
        fare: 85000,
        status: 'completed',
        rating: 4.8,
        review:
            'Tài xế rất thân thiện và lái xe an toàn. Chuyến đi rất thoải mái!',
        paymentMethod: 'Ví điện tử',
        tripDuration: '25',
      ),
      TripModel(
        id: '2',
        driverName: 'Trần Thị Bình',
        driverPhone: '0987654321',
        driverAvatar: '',
        vehicleNumber: '51F-67890',
        vehicleModel: 'Honda City',
        vehicleColor: 'Đen',
        pickupLocation: 'Crescent Mall, 101 Tôn Dật Tiên, Quận 7, TP.HCM',
        destinationLocation: 'Saigon Centre, 65 Lê Lợi, Quận 1, TP.HCM',
        tripDate: DateTime.now().subtract(const Duration(days: 1)),
        distance: 12.3,
        fare: 120000,
        status: 'completed',
        rating: 4.5,
        review: 'Xe sạch sẽ, tài xế đúng giờ. Rất hài lòng!',
        paymentMethod: 'Tiền mặt',
        tripDuration: '35',
      ),
      TripModel(
        id: '3',
        driverName: 'Lê Văn Cường',
        driverPhone: '0369852147',
        driverAvatar: '',
        vehicleNumber: '29H-54321',
        vehicleModel: 'Hyundai Accent',
        vehicleColor: 'Xanh',
        pickupLocation: 'Bitexco Financial Tower, 2 Hải Triều, Quận 1, TP.HCM',
        destinationLocation: 'Diamond Plaza, 34 Lê Duẩn, Quận 1, TP.HCM',
        tripDate: DateTime.now().subtract(const Duration(days: 2)),
        distance: 3.2,
        fare: 45000,
        status: 'cancelled',
        rating: 0,
        review: null,
        paymentMethod: null,
        tripDuration: null,
      ),
      TripModel(
        id: '4',
        driverName: 'Phạm Thị Dung',
        driverPhone: '0521478963',
        driverAvatar: '',
        vehicleNumber: '59A-98765',
        vehicleModel: 'Kia Morning',
        vehicleColor: 'Đỏ',
        pickupLocation: 'Takashimaya, 92-94 Nam Kỳ Khởi Nghĩa, Quận 1, TP.HCM',
        destinationLocation: 'Parkson, 45 Lê Thánh Tôn, Quận 1, TP.HCM',
        tripDate: DateTime.now().subtract(const Duration(days: 3)),
        distance: 2.8,
        fare: 40000,
        status: 'completed',
        rating: 4.9,
        review: 'Tuyệt vời! Tài xế rất chuyên nghiệp và xe rất sạch.',
        paymentMethod: 'Thẻ tín dụng',
        tripDuration: '12',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final trips = _getMockTrips();

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryWhite,
        elevation: 0,
        title: const Text(
          'Hoạt động',
          style: AppTheme.heading3,
        ),
        centerTitle: true,
      ),
      body: trips.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history_outlined,
                    size: 64,
                    color: AppTheme.mediumGray,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Chưa có hoạt động nào',
                    style: AppTheme.heading3,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Lịch sử hoạt động sẽ hiển thị ở đây',
                    style: AppTheme.body2,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: trips.length,
              itemBuilder: (context, index) {
                final trip = trips[index];
                return TripItem(
                  trip: trip,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => TripDetailScreen(trip: trip),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
