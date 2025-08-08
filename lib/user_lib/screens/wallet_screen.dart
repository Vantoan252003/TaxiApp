import 'package:flutter/material.dart';
import '../../core/constants/app_theme.dart';
import '../../data/models/wallet_model.dart';
import '../../presentation/payment/widgets/wallet_balance_card.dart';
import '../../presentation/payment/widgets/payment_method_card.dart';
import '../widgets/transaction_item.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  late WalletModel wallet;

  @override
  void initState() {
    super.initState();
    wallet = _getMockWalletData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryWhite,
        elevation: 0,
        title: const Text(
          'Ví',
          style: AppTheme.heading3,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => _showAddPaymentMethod(context),
            icon: const Icon(
              Icons.add,
              color: AppTheme.primaryBlack,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Balance Card
            WalletBalanceCard(wallet: wallet),

            const SizedBox(height: 24),

            // Payment Methods Section
            Row(
              children: [
                const Text(
                  'Phương thức thanh toán',
                  style: AppTheme.heading3,
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => _showAddPaymentMethod(context),
                  child: const Text('Thêm mới'),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Payment Methods List
            if (wallet.paymentMethods.isNotEmpty) ...[
              ...wallet.paymentMethods.map((method) => PaymentMethodCard(
                    paymentMethod: method,
                    onTap: () => _editPaymentMethod(context, method),
                    onDelete: () => _deletePaymentMethod(context, method),
                  )),
            ] else ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: AppTheme.cardDecoration,
                child: Column(
                  children: [
                    const Icon(
                      Icons.credit_card_outlined,
                      size: 48,
                      color: AppTheme.mediumGray,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Chưa có phương thức thanh toán',
                      style: AppTheme.body1.copyWith(
                        color: AppTheme.mediumGray,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Thêm phương thức thanh toán để thanh toán nhanh hơn',
                      style: AppTheme.body2.copyWith(
                        color: AppTheme.lightGray,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Recent Transactions Section
            Row(
              children: [
                const Text(
                  'Giao dịch gần đây',
                  style: AppTheme.heading3,
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => _showAllTransactions(context),
                  child: const Text('Xem tất cả'),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Transactions List
            if (wallet.recentTransactions.isNotEmpty) ...[
              ...wallet.recentTransactions.map((transaction) => TransactionItem(
                    transaction: transaction,
                  )),
            ] else ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: AppTheme.cardDecoration,
                child: Column(
                  children: [
                    const Icon(
                      Icons.receipt_long_outlined,
                      size: 48,
                      color: AppTheme.mediumGray,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Chưa có giao dịch nào',
                      style: AppTheme.body1.copyWith(
                        color: AppTheme.mediumGray,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Các giao dịch nạp tiền và thanh toán sẽ hiển thị ở đây',
                      style: AppTheme.body2.copyWith(
                        color: AppTheme.lightGray,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  WalletModel _getMockWalletData() {
    return WalletModel(
      id: 'wallet_001',
      balance: 125000.0,
      currency: 'VNĐ',
      paymentMethods: [
        PaymentMethod(
          id: 'pm_001',
          type: 'card',
          name: 'Visa',
          cardNumber: '1234567890123456',
          isDefault: true,
        ),
        PaymentMethod(
          id: 'pm_002',
          type: 'bank',
          name: 'Vietcombank',
          bankName: 'Vietcombank',
          isDefault: false,
        ),
        PaymentMethod(
          id: 'pm_003',
          type: 'ewallet',
          name: 'Momo',
          ewalletName: 'Momo',
          isDefault: false,
        ),
      ],
      recentTransactions: [
        Transaction(
          id: 'tx_001',
          type: 'debit',
          amount: 85000.0,
          description: 'Thanh toán chuyến đi #TR001',
          date: DateTime.now().subtract(const Duration(hours: 2)),
          status: 'completed',
          tripId: 'TR001',
        ),
        Transaction(
          id: 'tx_002',
          type: 'credit',
          amount: 100000.0,
          description: 'Nạp tiền từ thẻ Visa',
          date: DateTime.now().subtract(const Duration(days: 1)),
          status: 'completed',
        ),
        Transaction(
          id: 'tx_003',
          type: 'debit',
          amount: 65000.0,
          description: 'Thanh toán chuyến đi #TR002',
          date: DateTime.now().subtract(const Duration(days: 2)),
          status: 'completed',
          tripId: 'TR002',
        ),
        Transaction(
          id: 'tx_004',
          type: 'credit',
          amount: 50000.0,
          description: 'Nạp tiền từ Momo',
          date: DateTime.now().subtract(const Duration(days: 3)),
          status: 'completed',
        ),
        Transaction(
          id: 'tx_005',
          type: 'debit',
          amount: 75000.0,
          description: 'Thanh toán chuyến đi #TR003',
          date: DateTime.now().subtract(const Duration(days: 4)),
          status: 'completed',
          tripId: 'TR003',
        ),
      ],
    );
  }

  void _showAddPaymentMethod(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thêm phương thức thanh toán'),
        content: const Text(
            'Tính năng thêm phương thức thanh toán sẽ được phát triển sau.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  void _editPaymentMethod(BuildContext context, PaymentMethod method) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Chỉnh sửa phương thức thanh toán'),
        content:
            Text('Chỉnh sửa ${method.displayName} sẽ được phát triển sau.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  void _deletePaymentMethod(BuildContext context, PaymentMethod method) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa phương thức thanh toán'),
        content: Text('Bạn có chắc chắn muốn xóa ${method.displayName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Implement delete functionality
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Đã xóa ${method.displayName}'),
                  backgroundColor: AppTheme.successGreen,
                ),
              );
            },
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }

  void _showAllTransactions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tất cả giao dịch'),
        content:
            const Text('Màn hình tất cả giao dịch sẽ được phát triển sau.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }
}
