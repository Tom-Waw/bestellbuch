import 'package:flutter/material.dart';

import '../data/menu.dart';
import 'menu_item_box.dart';

class MenuGridView extends StatelessWidget {
  final Menu menu;

  MenuGridView({super.key, required this.menu}) {
    // Sort items in view
    menu.items.sort((a, b) => a.name.compareTo(b.name));
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: const EdgeInsets.all(8.0),
      crossAxisCount: 3,
      crossAxisSpacing: 8.0,
      mainAxisSpacing: 8.0,
      children: menu.items.map((item) => MenuItemBox(item: item)).toList(),
    );
  }
}
