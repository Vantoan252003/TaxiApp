import 'package:flutter/material.dart';

class PromoHeader extends StatelessWidget {
  const PromoHeader({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close, size: 24),
          ),
          const SizedBox(width: 16),
          const Text(
            'Khuyến mãi',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: const Row(
              children: [
                Icon(
                  Icons.star_outline_outlined,
                  color: Colors.amber,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  '120',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                )
              ],
            ),
          ),
        ],
      ),
      
    );
  }
}
