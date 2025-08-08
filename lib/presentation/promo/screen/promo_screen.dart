import 'package:flutter/material.dart';
import 'package:taxi_app/presentation/promo/widgets/promo_header_widget.dart';
import 'package:taxi_app/presentation/promo/widgets/promo_tabbar_widget.dart';

class PromoScreeen extends StatelessWidget {
  const PromoScreeen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[500],
      body: const Column(
        children: [PromoHeader(), Expanded(child: PromoTabbarWidget())],
      ),
    );
  }
}
