import 'package:flutter/material.dart';
import 'package:taxi_app/presentation/promo/widgets/promo_loyal_widget.dart';
import 'package:taxi_app/presentation/promo/widgets/promo_voucher_widget.dart';

class PromoTabbarWidget extends StatelessWidget {
  const PromoTabbarWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            color: Colors.white,
            child: const TabBar(
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.black,
              labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              tabs: [
                Tab(text: 'Ưu đãi'),
                Tab(
                  text: 'Đổi điểm',
                ),
              ],
            ),
          ),
          const Expanded(
              child: TabBarView(children: [
            PromoVoucherWidget(),
            PromoLoyalWidget(),
          ]))
        ],
      ),
    );
  }
}
