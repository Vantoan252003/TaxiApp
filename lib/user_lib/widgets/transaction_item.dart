import 'package:flutter/material.dart';
import '../../core/constants/app_theme.dart';
import '../../data/models/wallet_model.dart';

class TransactionItem extends StatelessWidget {
  final Transaction transaction;

  const TransactionItem({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.subtleCardDecoration,
      child: Row(
        children: [
          // Transaction icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getIconBackgroundColor(),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getIcon(),
              color: _getIconColor(),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          // Transaction details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.description,
                  style: AppTheme.body1.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      transaction.formattedDate,
                      style: AppTheme.caption.copyWith(
                        color: AppTheme.mediumGray,
                      ),
                    ),
                    if (transaction.tripId != null) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.accentBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Chuyến đi',
                          style: AppTheme.caption.copyWith(
                            color: AppTheme.accentBlue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          // Amount and status
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                transaction.formattedAmount,
                style: AppTheme.body1.copyWith(
                  fontWeight: FontWeight.w600,
                  color: transaction.isCredit
                      ? AppTheme.successGreen
                      : AppTheme.warningRed,
                ),
              ),
              const SizedBox(height: 4),
              _buildStatusChip(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip() {
    Color chipColor;
    String statusText;

    switch (transaction.status) {
      case 'completed':
        chipColor = AppTheme.successGreen;
        statusText = 'Thành công';
        break;
      case 'pending':
        chipColor = AppTheme.warningOrange;
        statusText = 'Đang xử lý';
        break;
      case 'failed':
        chipColor = AppTheme.warningRed;
        statusText = 'Thất bại';
        break;
      default:
        chipColor = AppTheme.mediumGray;
        statusText = 'Không xác định';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        statusText,
        style: AppTheme.caption.copyWith(
          color: chipColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _getIconBackgroundColor() {
    if (transaction.isCredit) {
      return AppTheme.successGreen.withOpacity(0.1);
    } else {
      return AppTheme.warningRed.withOpacity(0.1);
    }
  }

  Color _getIconColor() {
    if (transaction.isCredit) {
      return AppTheme.successGreen;
    } else {
      return AppTheme.warningRed;
    }
  }

  IconData _getIcon() {
    if (transaction.isCredit) {
      return Icons.add_circle_outline;
    } else {
      return Icons.remove_circle_outline;
    }
  }
}
