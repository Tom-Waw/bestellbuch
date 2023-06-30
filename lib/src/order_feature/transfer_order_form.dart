import 'package:flutter/material.dart' hide Table;
import 'package:get/get.dart';

import '../menu_feature/menu.dart';
import '../routes.dart';
import '../tables_feature/table.dart';
import 'checkout_controller.dart';
import 'order.dart';

class TransferOrderForm extends StatefulWidget {
  final Order order;

  const TransferOrderForm({super.key, required this.order});

  @override
  State<TransferOrderForm> createState() => _TransferOrderFormState();
}

class _TransferOrderFormState extends State<TransferOrderForm> {
  final Map<Product, int> _selection = {};
  double get _total => _selection.entries
      .fold(0.0, (sum, entry) => sum + entry.key.price * entry.value);
  bool get _isFullSelection => _selection.entries
      .every((entry) => entry.value == widget.order.items[entry.key]);

  @override
  void initState() {
    super.initState();
    _selection.addAll(widget.order.items);
    _selection.updateAll((key, value) => 0);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(child: _buildListView()),
        Row(
          children: [
            Text("Gesamt: $_total€"),
            const Spacer(),
            TextButton.icon(
              label: Text(
                !_isFullSelection ? "Alle auswählen" : "Alle abwählen",
              ),
              onPressed: () => setState(() {
                _isFullSelection
                    ? _selection.updateAll((key, value) => 0)
                    : _selection
                        .updateAll((key, value) => widget.order.items[key]!);
              }),
              icon: const Icon(Icons.select_all),
            ),
          ],
        ),
        ElevatedButton(
          onPressed: () async {
            dynamic table = await Get.toNamed(Routes.tables);
            if (table is! Table) return;

            Get.back();
            await CheckoutController.to.transferItemsToTable(table, _selection);
          },
          child: const Text(
            "Auswahl umbuchen",
            style: TextStyle(fontSize: 16.0),
          ),
        ),
      ],
    );
  }

  Widget _buildListView() => ListView.builder(
        itemCount: _selection.length,
        itemBuilder: (_, idx) {
          Product product = _selection.keys.elementAt(idx);
          int count = _selection.values.elementAt(idx);

          return ListTile(
            title: Text(product.name),
            subtitle: Text("$count x ${product.price}€"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                IconButton(
                  padding: const EdgeInsets.all(8.0),
                  onPressed: () => setState(() {
                    if (count <= 0) return;
                    _selection.update(product, (value) => value - 1);
                  }),
                  icon: const Icon(Icons.remove),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "$count / ${widget.order.items[product]}",
                      style: const TextStyle(fontSize: 20.0),
                    ),
                  ),
                ),
                IconButton(
                  padding: const EdgeInsets.all(8.0),
                  onPressed: () => setState(() {
                    if (count >= widget.order.items[product]!) {
                      return;
                    }
                    _selection.update(product, (value) => value + 1);
                  }),
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          );
        },
      );
}
