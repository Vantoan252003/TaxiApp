import 'package:flutter/material.dart';

class PromoItem extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final String price;
  final String description;
  final String note;
  final String quantity;
  final String buttonText;

  const PromoItem(
      {super.key,
      required this.icon,
      required this.title,
      required this.subtitle,
      required this.price,
      required this.description,
      required this.quantity,
      required this.note,
      required this.buttonText});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8)),
                child: Center(
                  child: Text(
                    icon,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontSize: 16),
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Text(
                          subtitle,
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        )),
                        Container(
                          padding:
                             const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey[100],
                          ),
                          child: Text(
                            quantity,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.black),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      price,
                      style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                    Container(
                      
                      child: Text('Mua goi va su dung'),
                    )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
