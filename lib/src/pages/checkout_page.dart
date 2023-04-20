import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/routes.dart';

class CheckoutPage extends StatelessWidget {
  final List<Map<String, dynamic>> data = [
    {'title': 'Ki-Schni', 'price': 15, 'qty': 2},
    {'title': 'Shisha Schoko Zitrone', 'price': 5, 'qty': 5},
    {'title': 'Glas Gerstensaft', 'price': 20, 'qty': 1},
    {'title': 'Pommes rot weiss', 'price': 20, 'qty': 5},
    {'title': 'Maggi', 'price': 10, 'qty': 5},
  ];

  final f = NumberFormat("\$###,###.00", "en_US");

  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    int _total = 0;
    _total = data.map((e) => e['price'] * e['qty']).reduce(
          (value, element) => value + element,
        );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter - Thermal Printer'),
        backgroundColor: Colors.redAccent,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (c, i) {
                return ListTile(
                  title: Text(
                    data[i]['title'].toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    "${f.format(data[i]['price'])} x ${data[i]['qty']}",
                  ),
                  trailing: Text(
                    f.format(
                      data[i]['price'] * data[i]['qty'],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            color: Colors.grey[200],
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Text(
                  "Total: ${f.format(_total)}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 80),
                Expanded(
                  child: TextButton.icon(
                    onPressed: () {
                      Get.toNamed(Routes.print);
                    },
                    icon: const Icon(Icons.print),
                    label: const Text('Print'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
