import 'package:flutter/material.dart';

class DestinationHeader extends StatelessWidget {
  final VoidCallback? onBackPressed;
  final VoidCallback? onMapSelectionPressed;

  const DestinationHeader({
    super.key,
    this.onBackPressed,
    this.onMapSelectionPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: onBackPressed ?? () => Navigator.pop(context),
      ),
      title: const Text(
        "Bạn muốn đi đâu?",
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      actions: [
        TextButton(
          onPressed: onMapSelectionPressed,
          child: const Text(
            "Chọn từ bản đồ",
            style: TextStyle(
              color: Colors.blue,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
