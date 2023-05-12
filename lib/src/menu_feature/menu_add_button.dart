import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'create_menu_page.dart';
import 'create_product_page.dart';

class MenuAddButton extends StatelessWidget {
  const MenuAddButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(FontAwesomeIcons.plus),
      onPressed: () => Get.defaultDialog(
        titlePadding: const EdgeInsets.symmetric(vertical: 22.0),
        title: "Menu erweitern",
        content: Column(
          children: [
            _createLink("Produkt", () {
              Get.to(() => const CreateProductPage());
            }),
            const Divider(thickness: 1.5),
            _createLink("Gruppierung", () {
              Get.to(() => const CreateMenuPage());
            }),
          ],
        ),
      ),
    );
  }

  Widget _createLink(String text, Function() onTap) {
    return InkWell(
      onTap: () {
        Get.back();
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Text(text, textAlign: TextAlign.center),
      ),
    );
  }
}
