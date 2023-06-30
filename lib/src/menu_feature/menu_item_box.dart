import 'package:flutter/material.dart' hide MenuController;
import 'package:get/get.dart';

import '../routes.dart';
import '../shared/utils.dart';
import 'menu.dart';
import 'menu_form.dart';
import 'menu_nav_controller.dart';
import 'product_form.dart';

class MenuItemBox extends StatelessWidget {
  final MenuItem item;
  final bool editable;
  final void Function()? exitEditMode;

  const MenuItemBox({
    super.key,
    required this.item,
    this.editable = false,
    this.exitEditMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.blue,
      ),
      child: InkWell(
        onTap: _onTap,
        child: Ink(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(item.name, textAlign: TextAlign.center),
              if (item is Product) ...[
                const SizedBox(height: 8.0),
                Text(
                  (item as Product).price.toStringAsFixed(2),
                  textAlign: TextAlign.center,
                ),
              ] else ...[
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text((item as Menu).allProducts.length.toString()),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _onTap() async {
    if (editable) {
      await Utils.showBottomSheet(
        "Menü anpassen",
        item is Menu
            ? MenuForm(menu: item as Menu)
            : ProductForm(product: item as Product),
      );
      return exitEditMode?.call();
    }

    if (item is Menu) return MenuNavController.to.open(item as Menu);

    if (Get.previousRoute == Routes.checkout) return Get.back(result: item);
  }
}
