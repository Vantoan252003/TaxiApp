import 'package:flutter/material.dart';
import '../../../core/constants/app_theme.dart';
import '../../../data/models/wallet_model.dart';

class PaymentMethodCard extends StatelessWidget {
  final PaymentMethod paymentMethod;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const PaymentMethodCard({
    super.key,
    required this.paymentMethod,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: AppTheme.cardDecoration,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Payment method icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _getIconBackgroundColor(),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getIcon(),
                    color: _getIconColor(),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                // Payment method details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            paymentMethod.displayName,
                            style: AppTheme.body1.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (paymentMethod.isDefault) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.successGreen.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Mặc định',
                                style: AppTheme.caption.copyWith(
                                  color: AppTheme.successGreen,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        paymentMethod.displayType,
                        style: AppTheme.body2.copyWith(
                          color: AppTheme.mediumGray,
                        ),
                      ),
                    ],
                  ),
                ),
                // Action buttons
                if (onDelete != null)
                  IconButton(
                    onPressed: onDelete,
                    icon: const Icon(
                      Icons.delete_outline,
                      color: AppTheme.warningRed,
                      size: 20,
                    ),
                  ),
                const Icon(
                  Icons.chevron_right,
                  color: AppTheme.mediumGray,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getIconBackgroundColor() {
    switch (paymentMethod.type) {
      case 'card':
        return AppTheme.accentBlue.withOpacity(0.1);
      case 'bank':
        return AppTheme.successGreen.withOpacity(0.1);
      case 'ewallet':
        return AppTheme.warningOrange.withOpacity(0.1);
      default:
        return AppTheme.backgroundColor;
    }
  }

  Color _getIconColor() {
    switch (paymentMethod.type) {
      case 'card':
        return AppTheme.accentBlue;
      case 'bank':
        return AppTheme.successGreen;
      case 'ewallet':
        return AppTheme.warningOrange;
      default:
        return AppTheme.mediumGray;
    }
  }

  IconData _getIcon() {
    switch (paymentMethod.type) {
      case 'card':
        return Icons.credit_card;
      case 'bank':
        return Icons.account_balance;
      case 'ewallet':
        return Icons.account_balance_wallet;
      default:
        return Icons.payment;
    }
  }
}
