import 'package:flutter/material.dart';
import '../../../core/constants/app_theme.dart';
import '../../../data/models/trip_model.dart';

class TripPaymentCard extends StatelessWidget {
  final TripModel trip;

  const TripPaymentCard({
    super.key,
    required this.trip,
  });

  @override
  Widget build(BuildContext context) {
    // Mock data for payment details
    final baseFare = trip.fare;
    final discount = baseFare * 0.1; // 10% discount
    final insurance = 5000.0; // 5,000 VNĐ insurance
    final totalFare = baseFare - discount + insurance;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Chi tiết thanh toán',
            style: AppTheme.heading3,
          ),
          const SizedBox(height: 20),

          // Base fare
          _buildPaymentRow(
            label: 'Cước phí cơ bản',
            value: '${baseFare.toStringAsFixed(0)} VNĐ',
            isPositive: true,
          ),

          const SizedBox(height: 12),

          // Discount
          _buildPaymentRow(
            label: 'Khuyến mãi',
            value: '-${discount.toStringAsFixed(0)} VNĐ',
            isPositive: false,
            icon: Icons.local_offer,
            iconColor: AppTheme.successGreen,
          ),

          const SizedBox(height: 12),

          // Insurance
          _buildPaymentRow(
            label: 'Bảo hiểm chuyến đi',
            value: '${insurance.toStringAsFixed(0)} VNĐ',
            isPositive: true,
            icon: Icons.security,
            iconColor: AppTheme.accentBlue,
          ),

          const Divider(height: 24),

          // Total
          Row(
            children: [
              Expanded(
                child: Text(
                  'Tổng thanh toán',
                  style: AppTheme.heading3.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                '${totalFare.toStringAsFixed(0)} VNĐ',
                style: AppTheme.heading2.copyWith(
                  color: AppTheme.accentBlue,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Payment method
          if (trip.paymentMethod != null) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.backgroundColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.borderColor),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.credit_card,
                    size: 20,
                    color: AppTheme.mediumGray,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Phương thức thanh toán: ',
                    style: AppTheme.body2.copyWith(
                      color: AppTheme.mediumGray,
                    ),
                  ),
                  Text(
                    trip.paymentMethod!,
                    style: AppTheme.body2.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPaymentRow({
    required String label,
    required String value,
    required bool isPositive,
    IconData? icon,
    Color? iconColor,
  }) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(
            icon,
            size: 16,
            color: iconColor ?? AppTheme.mediumGray,
          ),
          const SizedBox(width: 8),
        ],
        Expanded(
          child: Text(
            label,
            style: AppTheme.body2.copyWith(
              color: AppTheme.mediumGray,
            ),
          ),
        ),
        Text(
          value,
          style: AppTheme.body1.copyWith(
            fontWeight: FontWeight.w600,
            color: isPositive ? AppTheme.darkGray : AppTheme.successGreen,
          ),
        ),
      ],
    );
  }
}
