import 'package:flutter/material.dart';
import 'package:taxi_app/presentation/promo/items/promo_items.dart';

class PromoVoucherListWidget extends StatelessWidget {
  const PromoVoucherListWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Text(
                'Tất cả ưu đãi',
                style: TextStyle(fontSize: 16),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(8)),
                child: const Text(
                  'Gói tiết kiệm',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              )
            ],
          ),
        ),
        Expanded(
            child: ListView(
          children: const [
            PromoItem(
               icon: '🛵',
              title: 'beBike Thả ga đi chuyển',
              subtitle: 'Ưu đãi 20% lên đến 30K beBike',
              price: '35.000 đ',
              description: 'Đổi phương thức thanh toán để mua và áp dụng',
              note: 'Lưu ý: Gói tiết kiệm không được hoàn khi hủy chuyến',
              quantity: 'x99',
              buttonText: 'Mua gói và sử dụng',
            ),
          ],
        ))
      ],
    ));
  }
}
