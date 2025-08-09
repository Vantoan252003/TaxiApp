import 'package:flutter/material.dart';
import 'package:taxi_app/presentation/promo/widgets/promo_voucher_list_widget.dart';

class PromoVoucherWidget extends StatefulWidget {
  const PromoVoucherWidget({super.key});
  @override
  State<PromoVoucherWidget> createState() => _PromoVoucherWidgetState();
}

class _PromoVoucherWidgetState extends State<PromoVoucherWidget> {
  final TextEditingController _controller = TextEditingController();
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasText = _controller.text.trim().isNotEmpty;
    return Container(
        color: Colors.white,
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.confirmation_num_rounded,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                            child: TextField(
                          controller: _controller,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Nhập mã giảm giá',
                              hintStyle:
                                  TextStyle(color: Colors.grey, fontSize: 16),
                              isDense: true,
                              contentPadding: EdgeInsets.zero),
                          style: const TextStyle(fontSize: 16),
                          onChanged: (value) => setState(() {}),
                        ))
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Sử dụng',
                    style: TextStyle(
                        color: hasText ? Colors.black : Colors.grey[500],
                        fontWeight: FontWeight.w900,
                        fontSize: 16),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const PromoVoucherListWidget(),
                  )),
            ),
          ],
        ));
  }
}
